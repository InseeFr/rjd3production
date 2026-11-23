#' @importFrom checkmate assert_flag
#' @importFrom rjd3workspace read_workspace
#' @family regression tools
#' @rdname regression_tools
#' @export
retrieve_outliers <- function(
    jws,
    spec_type = NULL,
    verbose = TRUE
) {
    checkmate::assert_character(spec_type)
    spec_type <- tolower(spec_type)
    stopifnot(spec_type %in% c("reference", "estimation", "result"))
    checkmate::assert_flag(verbose)

    if ("result" %in% spec_type) {
        jws_compute(jws)
    }
    ws <- rjd3workspace::read_workspace(jws, compute = FALSE)

    sap <- ws[["processing"]][[1L]]
    ps_outliers <- data.frame(
        series = character(),
        name = character(),
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
        outliers <- list()

        if ("reference" %in% spec_type) {
            outliers <- c(
                outliers,
                sai[["referenceSpec"]][["regarima"]][["regression"]][[
                    "outliers"
                ]]
            )
        }
        if ("estimation" %in% spec_type) {
            outliers <- c(
                outliers,
                sai[["estimationSpec"]][["regarima"]][["regression"]][[
                    "outliers"
                ]]
            )
        }
        if ("result" %in% spec_type) {
            outliers <- c(
                outliers,
                sai[["resultSpec"]][["regarima"]][["regression"]][["outliers"]]
            )
        }

        if (length(outliers) > 0L) {
            outliers <- unique(outliers)
            outliers_name <- vapply(
                X = outliers,
                FUN = base::`[[`,
                FUN.VALUE = character(1L),
                "name"
            )
            outliers_type <- vapply(
                X = outliers,
                FUN = base::`[[`,
                FUN.VALUE = character(1L),
                "code"
            )
            outliers_date <- vapply(
                X = outliers,
                FUN = base::`[[`,
                FUN.VALUE = double(1L),
                "pos"
            ) |>
                base::as.Date(origin = "1970-01-01") |>
                as.character()

            ps_outliers <- rbind(
                ps_outliers,
                data.frame(
                    series = series_name,
                    name = outliers_name,
                    type = outliers_type,
                    date = outliers_date
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
    if (is.null(regressors_ud) || length(regressors_ud) == 0L) {
        return("No_TD")
    }

    regs_td <- NULL
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
        if (is.null(regs_td)) {
            return("LY")
        } else {
            return(paste0(regs_td, "_LY"))
        }
    }
    return(regs_td)
}

#' @importFrom checkmate assert_flag
#' @importFrom rjd3workspace read_workspace
#' @family regression tools
#' @rdname regression_tools
#' @export
retrieve_td <- function(
    jws,
    spec_type = NULL,
    verbose = TRUE
) {
    checkmate::assert_flag(verbose)
    checkmate::assert_character(spec_type, len = 1L)
    spec_type <- tolower(spec_type)
    stopifnot(spec_type %in% c("reference", "estimation", "result"))

    if (spec_type == "result") {
        jws_compute(jws)
    }
    ws <- rjd3workspace::read_workspace(jws, compute = FALSE)

    sap <- ws[["processing"]][[1L]]
    td <- data.frame(
        series = names(sap),
        regs = character(length(sap)),
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
        spec <- sai[[paste0(spec_type, "Spec")]]
        td[id_sai, "regs"] <- extract_td(spec)
    }

    return(td)
}
