#' @title Manage outliers from JDemetra+ workspaces
#'
#' @description
#' These functions allow extracting, exporting and importing outliers
#' detected in a JDemetra+ workspace:
#'
#' - [retrieve_outliers()] extracts outliers from a `.xml` workspace.
#' - [export_outliers()] saves extracted outliers into a YAML file.
#' - [import_outliers()] loads outliers back to a `.xml` workspace from a YAML file.
#'
#' They are useful for archiving and reusing outliers detected
#' during seasonal adjustment workflows.
#'
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#' @param x [list] A list of outliers, as returned by
#' [retrieve_outliers()].
#' @param path [\link[base]{character}] Path to a YAML file to write to
#' or read from. If missing, defaults to
#' `"regression/outliers_<random_name>.yaml"`.
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
#'   of existing (detected or pre-specified) outliers.
#' - `export_outliers()` invisibly returns the path of the YAML file
#'   written.
#' - `import_outliers()` returns a list of outliers read from a YAML file.
#'
#' @examples
#' library("rjd3workspace")
#' # Load a Workspace
#' file <- system.file("workspaces", "workspace_test.xml", package = "rjd3workspace")
#' jws <- jws_open(file)
#' outliers_table <- retrieve_outliers(jws, domain = FALSE, point = TRUE)
#'
#' path_outliers <- tempfile(pattern = "outliers-table", fileext = ".yaml")
#' export_outliers(outliers_table, path_outliers)
#' outliers_table_imported <- import_outliers(path = path_outliers)
#'
#' @importFrom rjd3workspace jws_open read_workspace
#' @importFrom tools file_path_sans_ext
#' @name outliers_tools
#' @export
retrieve_outliers <- function(
    jws,
    domain = TRUE,
    estimation = FALSE,
    point = FALSE,
    verbose = TRUE
) {
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
        date = character(),
        stringsAsFactors = FALSE
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
            regression_section <- sai[["domainSpec"]][["regarima"]][[
                "regression"
            ]]
        } else if (estimation) {
            regression_section <- sai[["estimationSpec"]][["regarima"]][[
                "regression"
            ]]
        } else if (point) {
            regression_section <- sai[["pointSpec"]][["regarima"]][[
                "regression"
            ]]
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

extract_td <- function(spec) {
    regression_section <- spec[["regarima"]][["regression"]]

    regressors_td <- regression_section[["td"]]
    if (regressors_td[["td"]] != "TD_NONE") {
        return(regressors_td[["td"]])
    } else if (regressors_td[["w"]] != 0L) {
        return("STOCK_TD")
    }

    regressors_ud <- regression_section[["td"]][["users"]]
    if (is.null(regressors_ud) || length(regressors_ud) == 0) {
        return("No_TD")
    }

    if (any(grepl(pattern = "REG1", x = regressors_ud, ignore.case = TRUE))) {
        regs_td <- "REG1"
    } else if (
        any(grepl(pattern = "REG5", x = regressors_ud, ignore.case = TRUE))
    ) {
        regs_td <- "REG5"
    } else if (
        any(grepl(pattern = "REG2", x = regressors_ud, ignore.case = TRUE))
    ) {
        regs_td <- "REG2"
    } else if (
        any(grepl(pattern = "REG3", x = regressors_ud, ignore.case = TRUE))
    ) {
        regs_td <- "REG3"
    } else if (
        any(grepl(pattern = "REG6", x = regressors_ud, ignore.case = TRUE))
    ) {
        regs_td <- "REG6"
    }
    if (
        any(
            grepl(
                pattern = "LeapYear",
                x = regressors_ud,
                ignore.case = TRUE
            ) |
                grepl(pattern = "LY", x = regressors_ud, ignore.case = TRUE)
        )
    ) {
        regs_td <- paste0(regs_td, "_LY")
    }
    return(regs_td)
}

#' @title Manage trading-day regressors (TD) from JDemetra+ workspaces
#'
#' @description
#' These functions allow to extract, export and import the
#' calendar (TD) regressors used in JDemetra+ workspaces:
#'
#' - [retrieve_td()] extracts the TD specification from a `.xml` workspace.
#' - [export_td()] saves extracted TD information into a YAML file.
#' - [import_td()] loads TD information back from a YAML file.
#'
#' They are useful for documenting and reusing the regression settings
#' applied in seasonal adjustment workflows.
#'
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#' @param x [\link[base]{list} | \link[base]{data.frame}] An object containing
#' the TD information, typically the output of [retrieve_td()].
#' @param path [\link[base]{character}] Path to a YAML file to write to
#' or read from. If missing, defaults to
#' `"regression/td_<ws_name>.yaml"`.
#' @param verbose [\link[base]{logical}] Whether to print informative
#' messages (default: `TRUE`).
#' @inheritParams outliers_tools
#'
#' @return
#' - `retrieve_td()` returns a [data.frame] with columns:
#'   - `series`: series names,
#'   - `regs`: TD regressor sets,
#' - `export_td()` invisibly returns the path of the YAML file written.
#' - `import_td()` returns a list or data structure read from YAML.
#'
#' @examples
#' library("rjd3workspace")
#' # Load a Workspace
#' file <- system.file("workspaces", "workspace_test.xml", package = "rjd3workspace")
#' jws <- jws_open(file)
#' td_table <- retrieve_td(jws, domain = FALSE, point = TRUE)
#'
#' path_td <- tempfile(pattern = "td-table", fileext = ".yaml")
#' export_td(td_table, path_td)
#' td_table_imported <- import_td(path = path_td)
#'
#' @importFrom rjd3workspace jws_open read_workspace
#' @importFrom tools file_path_sans_ext
#' @name td_tools
#' @export
retrieve_td <- function(
    jws,
    domain = TRUE,
    estimation = FALSE,
    point = FALSE,
    verbose = TRUE
) {
    if (domain + point + estimation != 1L) {
        stop("You have to choose one specification.")
    }

    if (point) {
        ws <- rjd3workspace::read_workspace(jws, compute = TRUE)
    } else {
        ws <- rjd3workspace::read_workspace(jws, compute = FALSE)
    }

    sap <- ws[["processing"]][[1L]]
    td <- data.frame(
        series = names(sap),
        regs = character(length(sap)),
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

        if (domain) {
            spec <- sai[["domainSpec"]]
        } else if (estimation) {
            spec <- sai[["estimationSpec"]]
        } else if (point) {
            spec <- sai[["pointSpec"]]
        }

        td[id_sai, "regs"] <- extract_td(spec)
    }

    return(td)
}
