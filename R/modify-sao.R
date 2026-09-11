#' @title Make a workspace crunchable
#'
#' @description
#' Complete and replace the ts metadata of a WS to make it crunchable
#'
#' @param jws A Java Workspace object, as returned by
#' [rjd3workspace::jws_open()] or [rjd3workspace::jws_new()].
#' @param verbose Boolean indicating whether to print additional information.
#'   Default is `TRUE`.
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
#' @importFrom utils tail
#' @importFrom rjd3workspace ws_sap_count
#' @importFrom rjd3workspace jws_sap
#' @importFrom rjd3workspace sap_sai_count
#' @importFrom rjd3workspace jsap_sai
#' @importFrom rjd3workspace sai_name
#' @importFrom rjd3workspace get_ts
#' @importFrom rjd3workspace set_ts
#' @importFrom rjd3providers txt_series
#' @importFrom checkmate assert_flag
#'
#' @export
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#' library("rjd3workspace")
#' library("rjd3x13")
#' library("rjd3toolkit")
#'
#' jws <- jws_new()
#' jsap <- jws_sap_new(jws, "sap1")
#' add_sa_item(
#'     jsap = jsap,
#'     name = "series_3",
#'     x = ABS[, 1],
#'     spec = x13_spec("RSA3")
#' )
#' jws <- make_ws_crunchable(jws)
#'
make_ws_crunchable <- function(jws, verbose = TRUE) {
    checkmate::assert_flag(verbose)

    data_dir <- file.path(
        tempdir(),
        paste0("ws-data-dir-", sample.int(10000L, 1L))
    )
    dir.create(data_dir)
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
                unlist(strsplit(
                    rjd3workspace::sai_name(jsai),
                    split = "\n",
                    fixed = TRUE
                )),
                n = 1L
            )
            data_sai <- date4ts::ts2df(rjd3workspace::get_ts(jsai)$data)
            colnames(data_sai) <- c("date", name)
            data_path <- file.path(
                data_dir,
                paste0("data-", id_sap, "-", id_sai, ".csv")
            )
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
#' @param context A modelling context for a Workspace. Defaults to NULL.
#' @param sap_name Name of the SA-Processing created. Defaults to "SAP1"
#' @param path Path leading to an input data file with metadata. If not NULL,
#'   the ts metadata are completed with the input file.
#' @param name_series Name of the series. Only used with univariate time series
#'   (with no colnames).
#'
#' @details
#' All series share the same specification (`spec`).
#'
#' @returns
#' A JDemetra+ workspace object (Java pointer) containing one SA-Processing with
#' one SA-Item per column of `x`.
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#' library("rjd3toolkit")
#'
#' # Create workspace
#' ws <- create_ws_from_data(ABS)
#'
#' @importFrom checkmate assert_list
#' @importFrom checkmate assert_named
#' @importFrom checkmate assert_set_equal
#' @importFrom rjd3workspace jws_new add_sa_item jws_sap_new
#' @importFrom rjd3x13 x13_spec
#' @export
create_ws_from_data <- function(
    x,
    spec = rjd3x13::x13_spec(),
    context = NULL,
    sap_name = "SAP1",
    path = NULL,
    name_series = "my_series"
) {
    if (!is.null(context)) {
        checkmate::assert_list(context)
        checkmate::assert_named(context)
        checkmate::assert_set_equal(names(context), c("calendars", "variables"))
    }

    jws <- rjd3workspace::jws_new()
    rjd3workspace::set_context(jws, modelling_context = context)
    if (!is.null(path)) {
        add_raw_data_path(jws, path)
    }
    jsap <- rjd3workspace::jws_sap_new(jws, sap_name)

    if (stats::is.ts(x) && !stats::is.mts(x)) {
        attr(x, "dim") <- c(length(x), 1L)
        attr(x, "class") <- c("mts", "ts", "matrix", "array")
        colnames(x) <- name_series
    }

    for (k in seq_len(ncol(x))) {
        series <- x[, k]
        rjd3workspace::add_sa_item(
            jsap = jsap,
            name = colnames(x)[k],
            x = series,
            spec = spec
        )
    }
    return(jws)
}

#' @title Add raw data from a file to a JWS workspace
#'
#' @description
#' This function completes the ts metadata (moniker) to make the workspace
#' refreshable and crunchable.
#'
#' @inheritParams make_ws_crunchable
#' @param path A character string. Path to the input data file. Must be a
#'   \code{.csv} file (support for \code{.xlsx} is not yet implemented).
#' @param ... Addional arguments passed to
#'   \code{rjd3providers::txt_data()} (e.g., delimiter, date format, clean
#'   missing argument...).
#'
#' @details
#' Currently, only CSV files are supported. Each column of the input file is
#' interpreted as a time series and matched against the series names in the
#' workspace.
#'
#' The difference with the function [`make_ws_crunchable`] is that
#' `add_raw_data_path()` will associate the workspace with a non temporary data
#' path.
#'
#' @returns The modified \code{jws} object invisibly.
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#'
#' library("rjd3workspace")
#' library("rjd3x13")
#' library("rjd3toolkit")
#'
#' my_data <- ABS
#' colnames(my_data) <- substr(colnames(my_data), start = 2L, stop = 12L)
#' path_ABS <- system.file("extdata", "ABS.csv", package = "rjd3providers")
#'
#' \donttest{
#' jws <- create_ws_from_data(my_data)
#' add_raw_data_path(jws, path_ABS, delimiter = "COMMA")
#' }
#'
#' @export
#' @importFrom rjd3workspace jws_sap sap_sai_count jsap_sai sai_name set_ts
#' @importFrom rjd3providers txt_data
#' @importFrom tools file_ext
add_raw_data_path <- function(jws, path, ...) {
    jsap <- rjd3workspace::jws_sap(jws, 1L)
    nb_sai <- rjd3workspace::sap_sai_count(jsap)

    if (tools::file_ext(path) == "csv") {
        my_data <- rjd3providers::txt_data(path, ...)
    } else if (tools::file_ext(path) == "xlsx") {
        stop("Not implemened yet.", call. = FALSE)
    } else {
        stop("The data file must be a .csv or an .xlsx file.", call. = FALSE)
    }

    for (id_sai in seq_len(nb_sai)) {
        jsai <- rjd3workspace::jsap_sai(jsap, id_sai)
        series_name <- rjd3workspace::sai_name(jsai)
        pos <- which(series_name == names(my_data$series))
        if (length(pos) == 1L) {
            rjd3workspace::set_ts(jsap, id_sai, my_data$series[[pos]])
        } else if (length(pos) == 0L) {
            warning(
                "There are no columns called ",
                series_name,
                " in ",
                basename(path),
                call. = FALSE
            )
        } else if (length(pos) > 1L) {
            warning(
                "Columns ",
                toString(pos),
                " have the same name : ",
                series_name,
                call. = FALSE
            )
        }
    }
    return(invisible(jws))
}
