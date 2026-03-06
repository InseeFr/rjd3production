date_pattern <- "\\d{4}-\\d{2}-\\d{2}"
outliers_type_pattern <- "(AO|TC|LS|SO)"

merge_lists <- function(list1, list2, verbose = TRUE) {
    intersect_elts <- intersect(names(list1), names(list2))
    if (length(intersect_elts) > 0L && verbose) {
        message(
            intersect_elts,
            " are present in the 2 objects and it won't be merged."
        )
    }
    setdiff_elts <- setdiff(names(list2), names(list1))
    if (length(setdiff_elts) > 0L && verbose) {
        message(
            setdiff_elts,
            " are present in the second object and will be added to the first one."
        )
    }
    return(c(list1, list2[setdiff_elts]))
}

merge_contexts <- function(context1 = NULL, context2 = NULL, verbose = TRUE) {
    if (is.null(context2)) {
        return(context1)
    } else if (is.null(context1)) {
        return(context2)
    }

    new_context <- rjd3toolkit::modelling_context(
        calendars = merge_lists(
            context1$calendars,
            context2$calendars,
            verbose
        ),
        variables = merge_lists(context1$variables, context2$variables, verbose)
    )
    return(new_context)
}

#' @title Assign outliers to a JDemetra+ workspace
#'
#' @description
#' This function updates a JDemetra+ workspace (`.xml`) by inserting
#' pre-specified outliers into the `domainSpec` of each series (SA-Item).
#'
#' @param outliers [\link[base]{list}] A named list where each element
#' corresponds to a series in the workspace created with [retrieve_outliers] or
#' [import_outliers].
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#'
#' @details
#' This function only modifies the first SA-Processing.
#'
#' @returns The object `jws` updated with new pre-specified outliers.
#'
#' @seealso
#' - [retrieve_outliers()] to extract outliers from an existing workspace.
#' - [export_outliers()] / [import_outliers()] to manage YAML files of outliers.
#'
#' @examples
#' \dontrun{
#' # Retrieve outliers from an existing workspace
#' outs <- retrieve_outliers("workspace.xml")
#'
#' # Reapply them to another workspace
#' assign_outliers(outliers = outs, ws_path = "workspace.xml")
#' }
#'
#' @importFrom rjd3workspace jws_open jws_sap sap_sai_count jsap_sai sai_name
#' @importFrom rjd3workspace read_sai set_name
#' @importFrom rjd3workspace set_specification set_domain_specification
#' @importFrom rjd3toolkit add_outlier
#' @importFrom tools file_path_sans_ext
#'
#' @export
assign_outliers <- function(jws, outliers) {
    jsap <- rjd3workspace::jws_sap(jws, 1L)

    for (id_sai in seq_len(rjd3workspace::sap_sai_count(jsap))) {
        jsai <- rjd3workspace::jsap_sai(jsap, idx = id_sai)
        series_name <- rjd3workspace::sai_name(jsai)
        cat(paste0(
            "S\u00e9rie ",
            series_name,
            ", ",
            id_sai,
            "/",
            rjd3workspace::sap_sai_count(jsap),
            "\n"
        ))

        # Outliers
        outliers_series <- outliers[[series_name]]

        # Création de la spec
        sai <- rjd3workspace::read_sai(jsai)
        new_estimationSpec <- estimationSpec <- sai$estimationSpec
        new_domainSpec <- domainSpec <- sai$domainSpec

        if (!is.null(outliers_series) && length(outliers_series) > 0L) {
            new_domainSpec <- domainSpec |>
                rjd3toolkit::add_outlier(
                    type = outliers_type_pattern |>
                        gregexpr(text = outliers_series) |>
                        regmatches(x = outliers_series) |>
                        do.call(what = c),
                    date = date_pattern |>
                        gregexpr(text = outliers_series) |>
                        regmatches(x = outliers_series) |>
                        do.call(what = c)
                )
            new_estimationSpec <- estimationSpec |>
                rjd3toolkit::add_outlier(
                    type = outliers_type_pattern |>
                        gregexpr(text = outliers_series) |>
                        regmatches(x = outliers_series) |>
                        do.call(what = c),
                    date = date_pattern |>
                        gregexpr(text = outliers_series) |>
                        regmatches(x = outliers_series) |>
                        do.call(what = c)
                )
        }

        rjd3workspace::set_specification(
            jsap = jsap,
            idx = id_sai,
            spec = new_estimationSpec
        )
        rjd3workspace::set_domain_specification(
            jsap = jsap,
            idx = id_sai,
            spec = new_domainSpec
        )
        rjd3workspace::set_name(jsap, idx = id_sai, name = series_name)
    }
    return(jws)
}

#' @title Assign calendar (TD) regressors to a JDemetra+ workspace
#'
#' @description
#' This function updates a JDemetra+ workspace (`.xml`) by assigning
#' user-defined trading day regressors (TD) to each series
#' (SA-Item), based on an external correspondence table, which can be created with
#' [retrieve_td()].
#'
#' This function modifies the `domainSpec` of each series by setting
#' `tradingdays` to `"UserDefined"` with the appropriate regressors
#' (`REG1` … `REG6`, optionally with `LY` for leap year).
#'
#' @param td [\link[base]{data.frame}] A data.frame with at least two columns:
#' - `series`: name of the series in the workspace.
#' - `regs`: standard INSEE TD set (`REG1`, `REG2`, …, `REG6`, with or
#' without `_LY`) (created by [retrieve_td] or [import_td]).
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#'
#' @details
#' This function only modifies the first SA-Processing.
#'
#' @returns The object `jws` updated with new td regressors.
#'
#' @examples
#' \dontrun{
#' # Load a workspace and apply INSEE TD sets
#' td_table <- retrieve_td("workspace.xml")
#' assign_td(td = td_table, ws_path = "workspace.xml")
#' }
#'
#' @importFrom rjd3workspace jws_open jws_sap sap_sai_count jsap_sai sai_name
#' @importFrom rjd3workspace sap_sai_count read_sai set_name save_workspace
#' @importFrom rjd3workspace set_specification set_domain_specification
#' @importFrom tools file_path_sans_ext
#'
#' @export
assign_td <- function(td, jws) {
    td <- as.data.frame(td)
    var_names <- get_named_variables(create_insee_context())
    jsap <- rjd3workspace::jws_sap(jws, 1L)

    for (id_sai in seq_len(rjd3workspace::sap_sai_count(jsap))) {
        jsai <- rjd3workspace::jsap_sai(jsap, idx = id_sai)
        series_name <- rjd3workspace::sai_name(jsai)
        cat(paste0(
            "S\u00e9rie ",
            series_name,
            ", ",
            id_sai,
            "/",
            rjd3workspace::sap_sai_count(jsap),
            "\n"
        ))
        jeu_regresseur <- td[
            which(td[["series"]] == series_name),
            "reg_selected"
        ]
        all_regs <- c(
            paste0("REG", rep(c(1:3, 5:6), each = 2), c("", "_LY")),
            "LY"
        )
        if (jeu_regresseur %in% all_regs) {
            td_variables <- var_names[[jeu_regresseur]]
        } else if (nzchar(jeu_regresseur)) {
            stop("Weird TD selection...", jeu_regresseur)
        } else {
            td_variables <- NULL
        }
        sai <- rjd3workspace::read_sai(jsai)
        new_estimationSpec <- estimationSpec <- sai$estimationSpec
        new_domainSpec <- domainSpec <- sai$domainSpec
        new_domainSpec <- domainSpec |>
            set_tradingdays(
                option = "UserDefined",
                uservariable = td_variables,
                test = "None"
            )
        new_estimationSpec <- estimationSpec |>
            set_tradingdays(
                option = "UserDefined",
                uservariable = td_variables,
                test = "None"
            )
        rjd3workspace::set_specification(
            jsap = jsap,
            idx = id_sai,
            spec = new_estimationSpec
        )
        rjd3workspace::set_domain_specification(
            jsap = jsap,
            idx = id_sai,
            spec = new_domainSpec
        )
        rjd3workspace::set_name(jsap, idx = id_sai, name = series_name)
    }

    context <- complete_context(rjd3workspace::get_context(jws))
    rjd3workspace::set_context(jws = jws, modelling_context = context)

    return(jws)
}

# Fonction d'ajout des regresseurs td Insee à un WS
add_insee_regressor <- function() {}
