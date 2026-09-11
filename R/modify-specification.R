#' @title Remove non-significant outliers from a JDemetra+ workspace
#'
#' @description
#' This function scans a JDemetra+ workspace (`.xml`) and removes
#' regression outliers whose p-values are above a given threshold.
#' Both the estimation specification and the reference specification are
#' updated accordingly, and the workspace file is saved in place.
#'
#' Typical use case: after estimation with user pre-specified outliers, outliers
#' with weak statistical significance (e.g. `p > 0.3`) are dropped to
#' simplify the regression specification.
#'
#' @param ws_path [\link[base]{character}] Path to a JDemetra+ workspace file
#' (usually with extension `.xml`).
#' @param threshold [\link[base]{numeric}] Maximum p-value for keeping
#' an outlier. Outliers with `Pr(>|t|) > threshold` are removed.
#' Default is `0.3`.
#' @param reference Boolean indicating if the reference specification should be
#' modified.
#' @param estimation Boolean indicating if the estimation specification should
#' be modified.
#' @inheritParams make_ws_crunchable
#'
#' @details
#' The function:
#'
#' - iterates over all the series (SA-Items) in the workspace,
#' - identifies outliers in the `regarima` specification,
#' - checks their p-values in the pre-processing regression summary,
#' - removes those with p-values above the threshold from both
#'   `estimationSpec` and, if present, `referenceSpec`,
#' - saves the workspace file.
#'
#' @returns
#' The function invisibly returns `NULL`, but it **modifies the workspace file
#' in place** (saved at the same location as `ws_path`).
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#'
#' library("rjd3workspace")
#' library("rjd3x13")
#' library("rjd3toolkit")
#'
#' \donttest{
#' new_spec <- x13_spec() |>
#'     add_outlier(type = "LS", date = "1990-01-01")
#' jws <- create_ws_from_data(x = ABS[, 1, drop = FALSE], spec = new_spec)
#' path_ws <- tempfile(pattern = "ws", fileext = ".xml")
#' save_workspace(jws, file = path_ws)
#'
#' # Remove non-significant outliers (p > 0.3) from a workspace
#' remove_non_significant_outliers(path_ws, threshold = 0.3, reference = TRUE)
#' }
#'
#' @importFrom checkmate assert_flag
#' @importFrom rjd3workspace jws_open jws_compute jws_sap sap_sai_count jsap_sai
#' @importFrom rjd3workspace read_sai sai_name set_specification
#' @importFrom rjd3workspace set_reference_specification set_name save_workspace
#' @importFrom rjd3toolkit remove_outlier
#' @importFrom tools file_path_sans_ext
#' @export
remove_non_significant_outliers <- function(
    ws_path,
    threshold = 0.3,
    reference = FALSE,
    estimation = FALSE,
    verbose = TRUE
) {
    checkmate::assert_flag(verbose)

    if (!reference && !estimation) {
        warning(
            "No SA-Items will be modified if neither referenceSpec",
            "nor estimationspec are selected.",
            call. = FALSE
        )
        return(invisible(NULL))
    }
    ws_name <- tools::file_path_sans_ext(basename(ws_path))
    if (verbose) {
        cat("\n\U1F3F7 WS ", ws_name, "\n")
    }
    jws <- rjd3workspace::jws_open(file = ws_path) |>
        remove_non_significant_outliers_jws(
            threshold = threshold,
            reference = reference,
            estimation = estimation,
            verbose = verbose
        )
    if (verbose) {
        cat("\U1F4BE Saving WS file\n")
    }
    rjd3workspace::save_workspace(
        jws = jws,
        file = ws_path,
        replace = TRUE
    )
}

#' @importFrom checkmate assert_flag
remove_non_significant_outliers_jws <- function(
    jws,
    threshold = 0.3,
    reference = FALSE,
    estimation = FALSE,
    verbose = TRUE
) {
    checkmate::assert_flag(verbose)

    if (!reference && !estimation) {
        warning(
            "No SA-Items will be modified if neither referenceSpec",
            "nor estimationspec are selected.",
            call. = FALSE
        )
        return(invisible(NULL))
    }
    rjd3workspace::jws_compute(jws)
    jsap <- rjd3workspace::jws_sap(jws, 1L)
    nb_sai <- rjd3workspace::sap_sai_count(jsap)

    for (id_sai in seq_len(nb_sai)) {
        if (verbose) {
            cat("\U1F4CC SAI n\UB0", id_sai, "\n")
        }
        jsai <- rjd3workspace::jsap_sai(jsap, idx = id_sai)
        sai <- read_sai(jsai)
        series_name <- rjd3workspace::sai_name(jsai)

        outliers_to_remove <- get_non_significant_outliers_jsai(
            jsai = jsai,
            threshold = threshold,
            verbose = verbose
        )

        if (nrow(outliers_to_remove) > 1L) {
            if (reference) {
                new_referenceSpec <- rjd3toolkit::remove_outlier(
                    x = sai$referenceSpec,
                    type = outliers_to_remove$type,
                    date = outliers_to_remove$date
                )
                rjd3workspace::set_reference_specification(
                    jsap = jsap,
                    idx = id_sai,
                    spec = new_referenceSpec
                )
            }

            if (estimation) {
                new_estimationSpec <- rjd3toolkit::remove_outlier(
                    x = sai$estimationSpec,
                    type = outliers_to_remove$type,
                    date = outliers_to_remove$date
                )
                rjd3workspace::set_specification(
                    jsap = jsap,
                    idx = id_sai,
                    spec = new_estimationSpec
                )
            }
            rjd3workspace::set_name(jsap, idx = id_sai, name = series_name)
        }
    }

    return(jws)
}

#' @importFrom checkmate assert_flag
get_non_significant_outliers_jsai <- function(
    jsai,
    threshold = 0.3,
    verbose = TRUE
) {
    checkmate::assert_flag(verbose)

    sai <- rjd3workspace::read_sai(jsai)
    series_name <- rjd3workspace::sai_name(jsai)

    outliers_to_remove <- data.frame(
        series = character(),
        name = character(),
        type = character(),
        date = character(),
        stringsAsFactors = FALSE
    )

    outliers <- sai$estimationSpec$regarima$regression$outliers
    if (is.null(sai$results)) {
        stop("Please compute your workspace", call. = FALSE)
    }
    xregs <- summary(sai$results)$preprocessing$xregs
    for (id_out in seq_along(outliers)) {
        outlier <- outliers[[id_out]]
        outlier_name <- paste0(outlier$code, " (", outlier$pos, ")")
        if (
            outlier_name %in%
                rownames(xregs) &&
                !is.na(xregs[outlier_name, "Pr(>|t|)"]) &&
                xregs[outlier_name, "Pr(>|t|)"] > threshold
        ) {
            outliers_to_remove <- rbind(
                outliers_to_remove,
                data.frame(
                    series = series_name,
                    name = outlier_name,
                    type = outlier$code,
                    date = outlier$pos
                )
            )
        }
    }

    return(outliers_to_remove)
}

#' @title Set span minimum to a value
#'
#' @param spec Specification (object of class `JD3_X13_SPEC` or
#' `JD3_TRAMOSEATS_SPEC`
#' @param d0 characters in the format "YYYY-MM-DD" to specify first date of the
#' span
#' @param model_span Boolean. Should the estimation (= model) span be modifed?
#' @param series_span Boolean. Should the series (= basic) span be modifed?
#' @param without_outliers Boolean. Should the outliers set before the starting
#' date be removed?
#' (Small crutch while waiting for the resolution of jdemetra/jdplus-main issue
#' 858.)
#'
#' @details
#' model_span = estimation_span
#' series_span = basic_span
#'
#' @importFrom zoo as.Date
#' @importFrom rjd3toolkit set_basic set_estimate
#'
#' @returns the modify specification (an `JD3_X13_SPEC` or `JD3_TRAMOSEATS_SPEC`
#'  object).
#'
#' @export
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#'
#' library("rjd3toolkit")
#' library("rjd3x13")
#' library("rjd3workspace")
#'
#' \donttest{
#' # Two demo workspaces (RSA3 and RSA5)
#' spec <- x13_spec("rsa3")
#' set_minimum_span(spec, "2012-01-01")
#' }
#'
set_minimum_span <- function(
    spec,
    d0,
    model_span = TRUE,
    series_span = TRUE,
    without_outliers = TRUE
) {
    if ((model_span || series_span) && without_outliers) {
        outliers <- spec$regarima$regression$outliers
        outliers_date <- vapply(
            X = outliers,
            FUN = base::`[[`,
            FUN.VALUE = double(1L),
            "pos"
        ) |>
            as.Date()
        cond <- outliers_date < as.Date(d0)
        if (!is.null(outliers) && any(cond)) {
            spec$regarima$regression$outliers <- outliers[!cond]
        }
    }

    if (series_span) {
        span <- d0
        current_span <- spec |>
            base::`[[`("regarima") |>
            base::`[[`("basic") |>
            base::`[[`("span") |>
            base::`[[`("d0")
        if (!is.null(current_span) && as.Date(span) < as.Date(current_span)) {
            span <- current_span
        }
        spec <- rjd3toolkit::set_basic(x = spec, type = "From", d0 = span)
    }
    if (model_span) {
        span <- d0
        current_span <- spec |>
            base::`[[`("regarima") |>
            base::`[[`("estimate") |>
            base::`[[`("span") |>
            base::`[[`("d0")
        if (!is.null(current_span) && as.Date(span) < as.Date(current_span)) {
            span <- current_span
        }
        spec <- rjd3toolkit::set_estimate(x = spec, type = "From", d0 = span)
    }
    return(spec)
}
