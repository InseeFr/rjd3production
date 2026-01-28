
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
#'
#' @export
#'
#' @examples
#' jws <- jws_new()
#' jsap <- jws_sap_new(jws, "sap1")
#' add_sa_item(
#'     jsap = jsap,
#'     name = "series_3",
#'     x = AirPassengers,
#'     spec = rjd3x13::x13_spec("RSA3")
#' )
#' jws <- make_ws_crunchable(jws)
#'
make_ws_crunchable <- function(jws, verbose = TRUE) {
    nb_sap <- rjd3workspace::ws_sap_count(jws)

    for (id_sap in seq_len(nb_sap)) {
        if (verbose) {
            cat("SAP n°", id_sap, "\n", sep = "")
        }
        jsap <- rjd3workspace::jws_sap(jws, id_sap)
        nb_sai <- rjd3workspace::sap_sai_count(jsap)
        for (id_sai in seq_len(nb_sai)) {
            if (verbose) {
                cat("SAI n°", id_sai, "\n", sep = "")
            }
            jsai <- rjd3workspace::jsap_sai(jsap, 1L)
            name <- jsai |> rjd3workspace::sai_name() |> strsplit(split = "\n") |> unlist() |> tail(n = 1)
            data_sai <- date4ts::ts2df(rjd3workspace::get_ts(jsai)$data)
            colnames(data_sai) <- c("date", name)

            data_path <- tempfile(fileext = ".csv")
            TBox::write_data(data = data_sai, path = data_path)

            ts_obj <- rjd3providers::txt_series(data_path, series = 1L, delimiter = "SEMICOLON")
            rjd3workspace::set_ts(jsap = jsap, idx = id_sai, ts_obj)
        }
    }
    return(jws)
}
