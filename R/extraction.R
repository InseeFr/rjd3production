#' @title Extract all series from a SA-Item
#'
#' @description
#' Extracts all available time series (pre-adjustment, decomposition, and final)
#' from a seasonal adjustment item (`jsai`) inside a JDemetra+ workspace.
#'
#' @param jsai A Java Seasonal Adjustment Item object, typically obtained via
#'   [jsap_sai()] after opening and computing a workspace with [jws_open()]
#'   and [jws_compute()].
#'
#' @return A `data.frame` with columns:
#' - `SAI`: name of the SAI,
#' - `series`: the type of series (e.g. `"y"`, `"sa"`, `"trend"`),
#' - `date`: observation dates,
#' - `value`: numeric values of the series.
#'
#' @examples
#' \dontrun{
#' library("rjd3workspace")
#' path <- file.path(tempdir(), "workspace_RSA3.xml")
#' jws <- jws_open(path)
#' jws_compute(jws)
#' jsap <- jws_sap(jws, 1L)
#' jsai <- jsap_sai(jsap, 1L)
#'
#' df <- get_series(jsai)
#' head(df)
#' }
#'
#' @importFrom rjd3workspace read_sai sai_name
#' @importFrom zoo as.Date
#' @export
get_series <- function(jsai) {
    res <- (rjd3workspace::read_sai(jsai))$results
    if (is.null(res)) {
        stop("Please compute your workspace")
    }
    output <- NULL
    all_series <- c(res$preadjust, res$decomposition, res$final)
    for (s in names(all_series)) {
        series <- all_series[[s]]
        if (!is.null(series)) {
            output <- rbind(
                output,
                data.frame(
                    series = s,
                    date = series |> time() |> zoo::as.Date(),
                    value = as.numeric(series)
                )
            )
        }
    }
    return(cbind(SAI = rjd3workspace::sai_name(jsai), output))
}

#' @title Retrieve a SA-Item by its name
#'
#' @description
#' Searches a workspace for a seasonal adjustment item (SAI) whose name matches
#' the user-supplied string and returns the corresponding object.
#'
#' @inheritParams make_ws_crunchable
#' @param series_name [character] Name of the SAI to retrieve.
#'
#' @return A Java Seasonal Adjustment Item object (`jsai`).
#'
#' @examples
#' \dontrun{
#' path <- file.path(tempdir(), "workspace_RSA3.xml")
#' jws <- jws_open(path)
#' jws_compute(jws)
#'
#' jsai <- get_jsai_by_name(jws, "series_1")
#' df <- get_series(jsai)
#' head(df)
#' }
#' @importFrom rjd3workspace jws_sap sap_sai_names jsap_sai
#'
#' @export
get_jsai_by_name <- function(jws, series_name) {
    jsap <- rjd3workspace::jws_sap(jws, idx = 1L)
    sai_names <- rjd3workspace::sap_sai_names(jsap)
    id <- which(sai_names == series_name)
    if (length(id) == 0) {
        stop("No SAI are named after ", series_name)
    }
    if (length(id) > 1) {
        stop("More than one SAI is named after ", series_name)
    }
    return(rjd3workspace::jsap_sai(jsap, idx = id))
}

#' @title Retrieve all the auxiliary variables from a workspace
#'
#' @description
#' Lists all the variables in a modelling context.
#'
#' @param context a modelling context
#'
#' @returns a list with all the groups and named variables
#' @examples
#' context_FR <- create_insee_context()
#' get_named_variables(context_FR)
#' @importFrom rjd3workspace jws_sap sap_sai_names jsap_sai
#'
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
