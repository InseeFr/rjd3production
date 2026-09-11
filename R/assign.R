#' @importFrom checkmate assert_flag
#' @importFrom checkmate assert_named
#' @importFrom checkmate assert_list
merge_lists <- function(list1, list2, verbose = TRUE) {
    checkmate::assert_named(list1)
    checkmate::assert_list(list1)
    checkmate::assert_named(list2)
    checkmate::assert_list(list2)
    checkmate::assert_flag(verbose)

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
            " are present in the second object and ",
            "will be added to the first one."
        )
    }
    return(c(list1, list2[setdiff_elts]))
}

#' @importFrom checkmate assert_flag
#' @importFrom checkmate assert_named
#' @importFrom checkmate assert_list
#' @importFrom rjd3toolkit modelling_context
merge_contexts <- function(context1 = NULL, context2 = NULL, verbose = TRUE) {
    if (is.null(context2)) {
        return(context1)
    } else if (is.null(context1)) {
        return(context2)
    }

    checkmate::assert_named(context1)
    checkmate::assert_list(context1)
    stopifnot(names(context1) %in% c("variables", "calendars"))
    checkmate::assert_named(context2)
    checkmate::assert_list(context2)
    stopifnot(names(context2) %in% c("variables", "calendars"))
    checkmate::assert_flag(verbose)

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

#' @importFrom rjd3workspace jws_sap sap_sai_count jsap_sai sai_name read_sai
#' @importFrom rjd3workspace set_specification set_reference_specification
#' @importFrom rjd3workspace set_name
#' @importFrom rjd3toolkit add_outlier
#' @importFrom checkmate assert_character
#' @importFrom checkmate assert_flag
#' @importFrom checkmate assert_data_frame
#' @importFrom checkmate assert_date
#' @family regression tools
#' @rdname regression_tools
#' @export
assign_outliers <- function(jws, outliers, spec_type = NULL, verbose = TRUE) {
    checkmate::assert_character(spec_type)
    spec_type <- tolower(spec_type)
    stopifnot(spec_type %in% c("reference", "estimation"))
    checkmate::assert_flag(verbose)
    checkmate::assert_data_frame(outliers, types = rep("character", 4L))
    stopifnot(outliers$type %in% c("AO", "LS", "TC", "SO"))
    checkmate::assert_date(as.Date(outliers$date))

    jsap <- rjd3workspace::jws_sap(jws, 1L)

    for (id_sai in seq_len(rjd3workspace::sap_sai_count(jsap))) {
        jsai <- rjd3workspace::jsap_sai(jsap, idx = id_sai)
        series_name <- rjd3workspace::sai_name(jsai)
        if (verbose) {
            cat(paste0(
                "S\u00e9rie ",
                series_name,
                ", ",
                id_sai,
                "/",
                rjd3workspace::sap_sai_count(jsap),
                "\n"
            ))
        }

        # Outliers
        outliers_series <- outliers[outliers$series == "RF1011", , drop = FALSE]

        if (nrow(outliers_series) > 0L) {
            sai <- rjd3workspace::read_sai(jsai)

            if ("reference" %in% spec_type) {
                new_referenceSpec <- rjd3toolkit::add_outlier(
                    x = sai$referenceSpec,
                    name = outliers_series$name,
                    type = outliers_series$type,
                    date = outliers_series$date
                )
                rjd3workspace::set_reference_specification(
                    jsap = jsap,
                    idx = id_sai,
                    spec = new_referenceSpec
                )
            }
            if ("estimation" %in% spec_type) {
                new_estimationSpec <- rjd3toolkit::add_outlier(
                    x = sai$estimationSpec,
                    name = outliers_series$name,
                    type = outliers_series$type,
                    date = outliers_series$date
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
    return(invisible(jws))
}

#' @importFrom checkmate assert_flag
#' @importFrom checkmate assert_data_frame
#' @importFrom rjd3workspace jws_sap sap_sai_count jsap_sai sai_name read_sai
#' @importFrom rjd3workspace set_specification set_reference_specification
#' @importFrom rjd3workspace get_context set_name
#' @importFrom rjd3toolkit set_tradingdays
#' @family regression tools
#' @rdname regression_tools
#' @export
assign_td <- function(jws, td, spec_type = NULL, verbose = TRUE) {
    checkmate::assert_character(spec_type)
    spec_type <- tolower(spec_type)
    stopifnot(spec_type %in% c("reference", "estimation"))
    checkmate::assert_flag(verbose)
    checkmate::assert_data_frame(td, types = rep("character", 2L))

    if (nrow(td) == 0L) {
        return(invisible(jws))
    }

    context <- rjd3workspace::get_context(jws)
    var_names <- get_named_variables(context)
    if (!all(td$regs %in% c("No_TD", names(var_names)))) {
        stop(
            setdiff(td$regs, c("No_TD", names(var_names))),
            " variables are not present in the WS.",
            " Please use the function `merge_contexts()` ",
            "to update your modelling context.",
            call. = FALSE
        )
    }
    jsap <- rjd3workspace::jws_sap(jws, 1L)

    for (id_sai in seq_len(rjd3workspace::sap_sai_count(jsap))) {
        jsai <- rjd3workspace::jsap_sai(jsap, idx = id_sai)
        series_name <- rjd3workspace::sai_name(jsai)
        if (verbose) {
            cat(paste0(
                "S\u00e9rie ",
                series_name,
                ", ",
                id_sai,
                "/",
                rjd3workspace::sap_sai_count(jsap),
                "\n"
            ))
        }
        chosen_set <- td[td$series == series_name, "regs"]
        if (length(chosen_set) == 1L && chosen_set != "No_TD") {
            td_variables <- var_names[[chosen_set]]

            sai <- rjd3workspace::read_sai(jsai)

            if ("reference" %in% spec_type) {
                new_referenceSpec <- rjd3toolkit::set_tradingdays(
                    x = sai$referenceSpec,
                    option = "UserDefined",
                    uservariable = td_variables,
                    test = "None"
                )
                rjd3workspace::set_reference_specification(
                    jsap = jsap,
                    idx = id_sai,
                    spec = new_referenceSpec
                )
            }
            if ("estimation" %in% spec_type) {
                new_estimationSpec <- rjd3toolkit::set_tradingdays(
                    x = sai$estimationSpec,
                    option = "UserDefined",
                    uservariable = td_variables,
                    test = "None"
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

    return(invisible(jws))
}
