#' @title Variables named in workspace
#'
#' @description
#' List all the variables in a modelling context.
#'
#' @param context a modelling context
#'
#' @returns a list with all the groups and named variables
#' @export
#'
get_named_variables <- function(context = NULL) {
    if (is.null(context)) {
        message("Without context, the output is NULL.")
        return(invisible(NULL))
    }
    all_vars <- context$variables
    named_vars <- lapply(seq_along(all_vars), function(k) {
        paste0(names(all_vars)[k], ".", names(all_vars[[k]]))
    })
    names(named_vars) <- names(all_vars)
    return(named_vars)
}

#' @title Manage outliers from JDemetra+ workspaces
#'
#' @description
#' These functions allow extracting, exporting and importing outliers
#' detected in a JDemetra+ workspace:
#'
#' - [retrieve_outliers()] extracts outliers from a `.xml` workspace.
#' - [export_outliers()] saves extracted outliers into a YAML file.
#' - [import_outliers()] loads outliers back from a YAML file.
#'
#' They are useful for archiving and reusing regression outliers detected
#' during seasonal adjustment workflows.
#'
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#' @param x [list] A list of outliers, as returned by
#' [retrieve_outliers()].
#' @param ws_name [\link[base]{character}] The name of the workspace,
#' used to build default YAML filenames.
#' @param path [\link[base]{character}] Path to a YAML file to write to
#' or read from. If missing, defaults to
#' `"regression/outliers_<ws_name>.yaml"`.
#' @param domain Boolean indicating if the outliers should be extracted from the
#' domain specification.
#' @param estimation Boolean indicating if the outliers should be extracted from the
#' estimation specification.
#' @param point Boolean indicating if the outliers should be extracted from the
#' point specification.
#' @param verbose [\link[base]{logical}] Whether to print informative
#' messages (default: `TRUE`).
#'
#' @return
#' - `retrieve_outliers()` returns a named list where each element
#'   corresponds to a series in the workspace and contains the names
#'   of detected outliers.
#' - `export_outliers()` invisibly returns the path of the YAML file
#'   written.
#' - `import_outliers()` returns a list of outliers read from YAML.
#'
#' @examples
#' library("rjd3workspace")
#' # Load a Workspace
#' file <- system.file("workspaces", "workspace_test.xml", package = "rjd3workspace")
#' jws <- jws_open(file)
#'
#' outliers <- retrieve_outliers(jws, point = TRUE, domain = FALSE, estimation = FALSE)
#' export_outliers(outliers, ws_name = "workspace1")
#' imported <- import_outliers(ws_name = "workspace1")
#'
#' @importFrom rjd3workspace jws_open read_workspace
#' @importFrom tools file_path_sans_ext
#' @name outliers_tools
#' @export
retrieve_outliers <- function(jws, domain = TRUE, estimation = FALSE,
                              point = FALSE, verbose = TRUE) {

    if (domain + point + estimation != 1L) {
        stop("You have to choose one specification.")
    }

    if (point) {
        ws <- rjd3workspace::read_workspace(jws, compute = TRUE)
    } else {
        ws <- rjd3workspace::read_workspace(jws, compute = FALSE)
    }

    sap <- ws[["processing"]][[1L]]
    ps_outliers <- data.frame(
        series = character(),
        type = character(),
        date = character()
    )

    for (id_sai in seq_along(sap)) {
        series_name <- names(sap)[id_sai]

        if (verbose) {
            cat(paste0(
                "S\u00e9rie ",
                series_name,
                ", ",
                id_sai,
                "/",
                length(sap),
                "\n"
            ))
        }

        sai <- sap[[id_sai]]

        if (domain) {
            regression_section <- sai[["domainSpec"]][["regarima"]][["regression"]]
        } else if (estimation) {
            regression_section <- sai[["estimationSpec"]][["regarima"]][["regression"]]
        } else if (point) {
            regression_section <- sai[["pointSpec"]][["regarima"]][["regression"]]
        }

        outliers <- regression_section[["outliers"]] |> unique()

        if (!is.null(outliers)) {
            type <- vapply(
                X = outliers,
                FUN = base::`[[`,
                FUN.VALUE = character(1L),
                "code"
            )
            date <- vapply(
                X = outliers,
                FUN = base::`[[`,
                FUN.VALUE = double(1L),
                "pos"
            ) |>
                as.Date() |>
                as.character()

            ps_outliers <- rbind(
                ps_outliers,
                data.frame(
                    series = series_name,
                    type = type,
                    date = date
                )
            )
        }
    }

    return(ps_outliers)
}

#' @title Manage working-day regressors (CJO) from JDemetra+ workspaces
#'
#' @description
#' These functions allow extracting, exporting, and importing the
#' *calendrier jours ouvrés* (CJO) regressors used in JDemetra+ workspaces:
#'
#' - [retrieve_td()] extracts the CJO specification from a `.xml` workspace.
#' - [export_td()] saves extracted CJO information into a YAML file.
#' - [import_td()] loads CJO information back from a YAML file.
#'
#' They are useful for documenting and reusing the regression settings
#' applied in seasonal adjustment workflows.
#'
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#' @param x [\link[base]{list} | \link[base]{data.frame}] An object containing
#' the CJO information, typically the output of [retrieve_td()].
#' @param ws_name [\link[base]{character}] The name of the workspace,
#' used to build default YAML filenames.
#' @param path [\link[base]{character}] Path to a YAML file to write to
#' or read from. If missing, defaults to
#' `"regression/td_<ws_name>.yaml"`.
#' @param verbose [\link[base]{logical}] Whether to print informative
#' messages (default: `TRUE`).
#'
#' @return
#' - `retrieve_td()` returns a [data.frame] with columns:
#'   - `series`: series names,
#'   - `regs`: CJO regressor specification (`REG1`, `REG2`, …, `REG6`,
#'     with or without `_LY`),
#'   - `series_span`: currently empty but reserved for series span.
#' - `export_td()` invisibly returns the path of the YAML file written.
#' - `import_td()` returns a list or data structure read from YAML.
#'
#' @examples
#' \dontrun{
#' ws_file <- "path/to/workspace.xml"
#'
#' # 1. Retrieve CJO specification
#' td <- retrieve_td(ws_file)
#'
#' # 2. Export to YAML
#' export_td(td, ws_name = "workspace1")
#'
#' # 3. Import back from YAML
#' imported <- import_td(x = NULL, ws_name = "workspace1")
#' }
#'
#' @importFrom rjd3workspace jws_open read_workspace
#' @importFrom tools file_path_sans_ext
#' @name td_tools
#' @export
retrieve_td <- function(jws) {
    ws <- rjd3workspace::read_workspace(jws, compute = FALSE)
    sap <- ws[["processing"]][[1L]]

    td <- data.frame(
        series = names(sap),
        regs = character(length(sap)),
        series_span = character(length(sap)),
        stringsAsFactors = FALSE
    )

    for (id_sai in seq_along(sap)) {
        series_name <- names(sap)[id_sai]
        cat(paste0(
            "S\u00e9rie ",
            series_name,
            ", ",
            id_sai,
            "/",
            length(sap),
            "\n"
        ))

        sai <- sap[[id_sai]]
        regression_section <- sai[["domainSpec"]][["regarima"]][["regression"]]
        regressors <- regression_section[["td"]][["users"]]

        regs_td <- "No_TD"
        if (any(grepl(pattern = "REG1", x = regressors, ignore.case = TRUE))) {
            regs_td <- "REG1"
        } else if (
            any(grepl(pattern = "REG5", x = regressors, ignore.case = TRUE))
        ) {
            regs_td <- "REG5"
        } else if (
            any(grepl(pattern = "REG2", x = regressors, ignore.case = TRUE))
        ) {
            regs_td <- "REG2"
        } else if (
            any(grepl(pattern = "REG3", x = regressors, ignore.case = TRUE))
        ) {
            regs_td <- "REG3"
        } else if (
            any(grepl(pattern = "REG6", x = regressors, ignore.case = TRUE))
        ) {
            regs_td <- "REG6"
        }
        if (
            any(
                grepl(
                    pattern = "LeapYear",
                    x = regressors,
                    ignore.case = TRUE
                ) |
                    grepl(pattern = "LY", x = regressors, ignore.case = TRUE)
            )
        ) {
            regs_td <- paste0(regs_td, "_LY")
        }
        td[id_sai, "regs"] <- regs_td
    }

    return(td)
}
