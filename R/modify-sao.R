#' @title Make a workspace crunchable
#'
#' @description
#' Complete and replace the ts metadata of a WS to make it crunchable
#'
#' @param jws The java representation of the workspace
#' @param verbose Boolean. Print additional informations.
#'
#' @details
#' New metadata are added from temporary files created on the heap. Thus, this
#' operation is not intended to make the workspace crunchable in a stable way
#' over time, but rather for a short period of time for testing purposes, in
#' particular when we are sent a workspace without the raw data.
#'
#' @returns A java workspace (as jws) but with new ts metadata
#'
#' @importFrom TBox write_data
#' @importFrom date4ts ts2df
#' @importFrom rjd3workspace ws_sap_count
#' @importFrom rjd3workspace jws_sap
#' @importFrom rjd3workspace sap_sai_count
#' @importFrom rjd3workspace jsap_sai
#' @importFrom rjd3workspace sai_name
#' @importFrom rjd3workspace get_ts
#' @importFrom rjd3workspace set_ts
#' @importFrom rjd3providers txt_series
#'
#' @export
#'
#' @examples
#' library("rjd3workspace")
#' library("rjd3x13")
#'
#' jws <- jws_new()
#' jsap <- jws_sap_new(jws, "sap1")
#' add_sa_item(
#'     jsap = jsap,
#'     name = "series_3",
#'     x = AirPassengers,
#'     spec = x13_spec("RSA3")
#' )
#' jws <- make_ws_crunchable(jws)
#'
make_ws_crunchable <- function(jws, verbose = TRUE) {
    nb_sap <- rjd3workspace::ws_sap_count(jws)
    for (id_sap in seq_len(nb_sap)) {
        if (verbose) {
            cat("SAP n\ub0", id_sap, "\n", sep = "")
        }
        jsap <- rjd3workspace::jws_sap(jws, id_sap)
        nb_sai <- rjd3workspace::sap_sai_count(jsap)
        for (id_sai in seq_len(nb_sai)) {
            if (verbose) {
                cat("SAI n\ub0", id_sai, "\n", sep = "")
            }
            jsai <- rjd3workspace::jsap_sai(jsap, id_sai)
            name <- tail(
                unlist(strsplit(rjd3workspace::sai_name(jsai), split = "\n", fixed = TRUE)),
                n = 1
            )
            data_sai <- date4ts::ts2df(rjd3workspace::get_ts(jsai)$data)
            colnames(data_sai) <- c("date", name)
            data_path <- tempfile(fileext = ".csv")
            TBox::write_data(data = data_sai, path = data_path)
            ts_obj <- rjd3providers::txt_series(
                data_path,
                series = 1L,
                delimiter = "SEMICOLON"
            )
            rjd3workspace::set_ts(jsap = jsap, idx = id_sai, ts_obj)
        }
    }
    return(jws)
}

#' @title Create a Workspace from Data
#'
#' @description
#' Creates a new JDemetra+ workspace with all columns of a time series object
#' using a specified specification.
#'
#' Each column of `x` is interpreted as a separate time series and added to a
#' newly created Seasonal Adjustment Processing (SAP).
#'
#' @param x A time series object (e.g. `ts`, `mts`, or matrix coercible to `ts`)
#' where each column represents a series to be seasonally adjusted.
#' Column names are used as SA-Item names.
#' @param spec A JDemetra+ specification. Defaults to `rjd3x13::x13_spec()`.
#'
#' @details
#' All series share the same specification (`spec`).
#'
#' @returns
#' A JDemetra+ workspace object (Java pointer) containing one SA-Processing with
#' one SA-Item per column of `x`.
#'
#' @examples
#' data(AirPassengers)
#'
#' # Create a multivariate time series
#' x <- cbind(
#'   series1 = AirPassengers,
#'   series2 = log(AirPassengers)
#' )
#'
#' # Create workspace
#' ws <- create_ws_from_data(x)
#'
#' @importFrom rjd3workspace jws_new
#' @importFrom rjd3workspace add_sa_item
#' @importFrom rjd3workspace jws_sap_new
#' @export
create_ws_from_data <- function(x, spec = rjd3x13::x13_spec()) {
    jws <- rjd3workspace::jws_new()
    jsap <- rjd3workspace::jws_sap_new(jws, "SAP1")
    for (k in seq_len(ncol(x))) {
        series <- x[, k]
        rjd3workspace::add_sa_item(
            jsap,
            name = colnames(x)[k],
            x = series,
            spec = spec
        )
    }
    return(jws)
}
