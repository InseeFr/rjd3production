date_pattern <- "\\d{4}-\\d{2}-\\d{2}"
outliers_type_pattern <- "(AO|TC|LS|SO)"

complete_context <- function(context = NULL) {
    return(context)
}

#' @title Assign outliers to a JDemetra+ workspace
#'
#' @description
#' This function updates a JDemetra+ workspace (`.xml`) by inserting
#' pre-specified outliers into the `domainSpec` of each seasonal adjustment
#' model (SAI).
#' Typically, the list of outliers is created with [retrieve_outliers()] and
#' stored/exported with [export_outliers()].
#'
#' @param outliers [\link[base]{list}] A named list where each element corresponds
#' to a series in the workspace.
#' Each element should be a character vector of outlier specifications
#' (e.g. `"AO (2020-03)"`, `"LS (2008-09)"`).
#'
#' @param ws_path [\link[base]{character}] Path to a JDemetra+ workspace file
#' (usually with extension `.xml`).
#'
#' @details
#' For each series in the workspace:
#' - The function looks up the corresponding entry in the `outliers` list.
#' - If outliers are specified, they are split into **type** (`AO`, `LS`, `TC`, …)
#'   and **date** (e.g. `"2020-03"`) using regex patterns.
#' - These outliers are then added into the `domainSpec` of the model using
#'   [add_outlier()].
#'
#' The modified workspace is saved **in place** (argument `replace = TRUE`).
#'
#' @return
#' Invisibly returns `NULL`. The workspace file at `ws_path` is updated on disk
#' with the new outliers.
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
#' @importFrom rjd3workspace jws_open jws_sap sap_sai_count jsap_sai sai_name read_sai set_specification set_domain_specification set_name
#' @importFrom rjd3toolkit add_outlier
#' @importFrom tools file_path_sans_ext
#'
#' @export
assign_outliers <- function(outliers, ws_path) {
    jws <- rjd3workspace::jws_open(file = ws_path)
    ws_name <- ws_path |> basename() |> tools::file_path_sans_ext()
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

    # Save WS automatique
    rjd3workspace::save_workspace(
        jws = jws,
        file = ws_path,
        replace = TRUE
    )
}

#' @title Assign CJO regressors to a JDemetra+ workspace
#'
#' @description
#' This function updates a JDemetra+ workspace (`.xml`) by assigning
#' user-defined trading day regressors (CJO) to each seasonal adjustment model
#' (SAI), based on an external classification (typically created with
#' [retrieve_cjo()]).
#'
#' The function modifies the `domainSpec` of each series by setting
#' `tradingdays` to `"UserDefined"` with the appropriate regressors
#' (`REG1` … `REG6`, optionally with `LY` for leap year).
#'
#' @param cjo [\link[base]{data.frame}] A data.frame with at least two columns:
#' - `series`: names of the series in the workspace.
#' - `regs`: the standard INSEE CJO set (`REG1`, `REG2`, …, `REG6`, with or without `_LY`).
#'
#' Typically this table is produced by [retrieve_cjo()].
#'
#' @param ws_path [\link[base]{character}] Path to a JDemetra+ workspace file
#' (usually with extension `.xml`).
#'
#' @details
#' For each series in the workspace:
#' - the function looks up its assigned `regs` in the `cjo` table,
#' - translates the label (`REG1`, `REG2`, …) into the corresponding
#'   user-defined regressors (e.g. `r.REG1_Semaine`, `r.REG5_Lundi`, …),
#' - updates the `domainSpec` with `set_tradingdays(option = "UserDefined", ...)`,
#' - saves the modified workspace.
#'
#' The file is overwritten in place (`replace = TRUE`).
#'
#' @return
#' Invisibly returns `NULL`. The workspace file at `ws_path` is updated
#' on disk with the new CJO regressors.
#'
#' @examples
#' \dontrun{
#' # Load a workspace and apply INSEE CJO sets
#' cjo_table <- retrieve_cjo("workspace.xml")
#' assign_cjo(cjo = cjo_table, ws_path = "workspace.xml")
#' }
#'
#' @importFrom rjd3workspace jws_open jws_sap sap_sai_count jsap_sai sai_name sap_sai_count read_sai set_specification set_domain_specification set_name save_workspace
#' @importFrom tools file_path_sans_ext
#'
#' @export
assign_cjo <- function(cjo, ws_path) {
    cjo <- as.data.frame(cjo)

    var_names <- get_named_variables(create_insee_context())

    jws <- rjd3workspace::jws_open(file = ws_path)
    ws_name <- tools::file_path_sans_ext(basename(ws_path))
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
        jeu_regresseur <- cjo[
            which(cjo[["series"]] == series_name),
            "reg_selected"
        ]
        all_regs <- c(
            paste0("REG", rep(c(1:3, 5:6), each = 2), c("", "_LY")),
            "LY"
        )
        if (jeu_regresseur %in% all_regs) {
            cjo_variables <- var_names[[jeu_regresseur]]
        } else if (nzchar(jeu_regresseur)) {
            stop("Weird TD selection...", jeu_regresseur)
        } else {
            cjo_variables <- NULL
        }
        sai <- rjd3workspace::read_sai(jsai)
        new_estimationSpec <- estimationSpec <- sai$estimationSpec
        new_domainSpec <- domainSpec <- sai$domainSpec
        new_domainSpec <- domainSpec |>
            set_tradingdays(
                option = "UserDefined",
                uservariable = cjo_variables,
                test = "None"
            )
        new_estimationSpec <- estimationSpec |>
            set_tradingdays(
                option = "UserDefined",
                uservariable = cjo_variables,
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
    rjd3workspace::save_workspace(
        jws = jws,
        file = ws_path,
        replace = TRUE
    )
}

# Fonction d'ajout des regresseurs cjo Insee à un WS
add_insee_regressor <- function() {}
