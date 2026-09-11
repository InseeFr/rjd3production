#' @importFrom rlang expr_text
keep_format <- function(x) {
    if (is.list(x)) {
        output <- x |>
            lapply(FUN = rlang::expr_text) |>
            lapply(FUN = paste0, collapse = "\n\t")
    } else {
        output <- rlang::expr_text(x)
    }
    return(output)
}

rev_add_outlier <- function(x) {
    if (is.null(x$regarima$regression$outliers)) {
        return(NULL)
    }
    spec_args <- list()
    outliers <- x$regarima$regression$outliers

    spec_args$type <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "code"
    )
    spec_args$date <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "pos"
    )
    spec_args$name <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    )
    spec_args$coef <- outliers |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = function(coeff) {
            if (is.null(coeff)) {
                coeff <- 0L
            }
            return(coeff)
        }) |>
        as.double()

    code <- paste0(
        "rjd3toolkit::add_outlier(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_add_ramp <- function(x) {
    if (is.null(x$regarima$regression$ramps)) {
        return(NULL)
    }
    spec_args <- list()
    ramps <- x$regarima$regression$ramps

    spec_args$start <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "start"
    )
    spec_args$end <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "end"
    )
    spec_args$name <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    )
    spec_args$coef <- ramps |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = function(coeff) {
            if (is.null(coeff)) {
                coeff <- 0L
            }
            return(coeff)
        }) |>
        as.double()

    code <- paste0(
        "rjd3toolkit::add_ramp(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_one_usrdefvar <- function(spec_args) {
    spec_args$label <- spec_args$name

    group_name <- strsplit(x = spec_args$id, split = ".", fixed = TRUE)[[1L]]
    spec_args$group <- group_name[1L]
    spec_args$name <- group_name[2L]
    spec_args$id <- NULL

    if (!is.null(spec_args$coef)) {
        spec_args$coef <- spec_args$coef$value
    }

    code <- paste0(
        "rjd3toolkit::add_usrdefvar(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_add_usrdefvar <- function(x) {
    if (is.null(x$regarima$regression$users)) {
        return(NULL)
    }
    code <- vapply(
        x$regarima$regression$users,
        FUN = rev_one_usrdefvar,
        FUN.VALUE = character(1L)
    ) |>
        paste(collapse = " |>\n")
    return(code)
}

rev_set_x11 <- function(x) {
    spec_args <- x$x11

    spec_args$lsigma <- spec_args$lsig
    spec_args$lsig <- NULL
    spec_args$usigma <- spec_args$usig
    spec_args$usig <- NULL
    spec_args$fcasts <- spec_args$nfcasts
    spec_args$nfcasts <- NULL
    spec_args$bcasts <- spec_args$nbcasts
    spec_args$nbcasts <- NULL
    spec_args$seasonal.comp <- spec_args$seasonal
    spec_args$seasonal <- NULL
    spec_args$henderson.filter <- spec_args$henderson
    spec_args$henderson <- NULL
    spec_args$seasonal.filter <- spec_args$sfilters
    spec_args$sfilters <- NULL
    spec_args$calendar.sigma <- spec_args$sigma
    spec_args$sigma <- NULL
    spec_args$sigma.vector <- spec_args$vsigmas
    spec_args$vsigmas <- NULL
    spec_args$exclude.forecast <- spec_args$excludefcasts
    spec_args$excludefcasts <- NULL

    spec_args$mode <- switch(
        spec_args$mode,
        UNKNOWN = "UNDEFINED",
        spec_args$mode
    )
    spec_args$seasonal.filter <- gsub(
        pattern = "FILTER_",
        replacement = "",
        x = spec_args$seasonal.filter,
        fixed = TRUE
    )
    spec_args$bias <- switch(
        spec_args$bias,
        RATIO = NA,
        spec_args$bias
    )
    if (length(spec_args$sigma.vector) == 0L) {
        spec_args$sigma.vector <- NULL
    }

    code <- paste0(
        "rjd3x13::set_x11(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_transform <- function(x) {
    spec_args <- x$regarima$transform

    spec_args$fun <- switch(
        spec_args$fn,
        LEVEL = "NONE",
        spec_args$fn
    )
    spec_args$fn <- NULL
    code <- paste0(
        "rjd3toolkit::set_transform(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_easter <- function(x) {
    spec_args <- x$regarima$regression$easter
    spec_args$enabled <- toupper(spec_args$type) != "UNUSED"
    if (spec_args$type == "JULIAN") {
        spec_args$julian <- TRUE
    }

    spec_args$type <- NULL

    if (!is.null(spec_args$coefficient)) {
        spec_args$coef <- spec_args$coefficient$value
        spec_args$coef.type <- spec_args$coefficient$type
    }
    spec_args$coefficient <- NULL
    code <- paste0(
        "rjd3toolkit::set_easter(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_basic <- function(x) {
    spec_args <- c(x$regarima$basic, x$regarima$basic$span)
    spec_args$span <- NULL
    names(spec_args)[
        names(spec_args) == "preliminaryCheck"
    ] <- "preliminary.check"
    code <- paste0(
        "rjd3toolkit::set_basic(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_estimate <- function(x) {
    spec_args <- c(x$regarima$estimate, x$regarima$estimate$span)
    spec_args$span <- NULL
    code <- paste0(
        "rjd3toolkit::set_estimate(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_automodel <- function(x) {
    spec_args <- x$regarima$automodel
    spec_args$acceptdefault <- spec_args$acceptdef
    spec_args$acceptdef <- NULL
    spec_args$ljungboxlimit <- spec_args$ljungbox
    spec_args$ljungbox <- NULL
    spec_args$reducecv <- spec_args$predcv
    spec_args$predcv <- NULL
    spec_args$fct <- NULL
    code <- paste0(
        "rjd3toolkit::set_automodel(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_arima <- function(x) {
    spec_args <- c(x$regarima$arima, x$regarima$regression$mean)
    spec_args$mean <- spec_args$value
    spec_args$value <- NULL
    spec_args$mean.type <- spec_args$type
    spec_args$type <- NULL
    if ("phi" %in% names(spec_args) && is.null(spec_args$phi)) {
        spec_args$p <- NULL
    } else if (is.null(spec_args$phi)) {
        spec_args$p <- 0L
    } else {
        spec_args$p <- ncol(spec_args$phi)
        spec_args$coef <- c(spec_args$coef, as.numeric(spec_args$phi[1L, ]))
        spec_args$coef.type <- c(
            spec_args$coef.type,
            as.character(spec_args$phi[2L, ])
        )
    }
    if ("theta" %in% names(spec_args) && is.null(spec_args$theta)) {
        spec_args$q <- NULL
    } else if (is.null(spec_args$theta)) {
        spec_args$q <- 0L
    } else {
        spec_args$q <- ncol(spec_args$theta)
        spec_args$coef <- c(spec_args$coef, as.numeric(spec_args$theta[1L, ]))
        spec_args$coef.type <- c(
            spec_args$coef.type,
            as.character(spec_args$theta[2L, ])
        )
    }
    if ("bphi" %in% names(spec_args) && is.null(spec_args$bphi)) {
        spec_args$bp <- NULL
    } else if (is.null(spec_args$bphi)) {
        spec_args$bp <- 0L
    } else {
        spec_args$bp <- ncol(spec_args$bphi)
        spec_args$coef <- c(spec_args$coef, as.numeric(spec_args$bphi[1L, ]))
        spec_args$coef.type <- c(
            spec_args$coef.type,
            as.character(spec_args$bphi[2L, ])
        )
    }
    if ("btheta" %in% names(spec_args) && is.null(spec_args$btheta)) {
        spec_args$bq <- NULL
    } else if (is.null(spec_args$btheta)) {
        spec_args$bq <- 0L
    } else {
        spec_args$bq <- ncol(spec_args$btheta)
        spec_args$coef <- c(spec_args$coef, as.numeric(spec_args$btheta[1L, ]))
        spec_args$coef.type <- c(
            spec_args$coef.type,
            as.character(spec_args$btheta[2L, ])
        )
    }
    spec_args$phi <- NULL
    spec_args$theta <- NULL
    spec_args$bphi <- NULL
    spec_args$btheta <- NULL
    spec_args$period <- NULL
    code <- paste0(
        "rjd3toolkit::set_arima(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_benchmarking <- function(x) {
    spec_args <- x$benchmarking
    if (!is.null(spec_args$target)) {
        spec_args$target <- switch(
            spec_args$target,
            TARGET_CALENDARADJUSTED = "CALENDARADJUSTED",
            TARGET_ORIGINAL = "ORIGINAL",
            NA
        )
    }
    if (!is.null(spec_args$bias)) {
        spec_args$bias <- switch(
            spec_args$bias,
            BIAS_MULTIPLICATIVE = "MULTIPLICATIVE",
            BIAS_ADDITIVE = "ADDITIVE",
            BIAS_NONE = "NONE",
            NA
        )
    }
    code <- paste0(
        "rjd3toolkit::set_benchmarking(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_outlier <- function(x) {
    spec_args <- c(x$regarima$outlier, x$regarima$outlier$span)
    spec_args$outliers.type <- vapply(
        X = spec_args$outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "type"
    )
    spec_args$critical.value <- vapply(
        X = spec_args$outliers,
        FUN = "[[",
        FUN.VALUE = numeric(1L),
        "va"
    )
    spec_args$outliers <- NULL
    spec_args$span <- NULL
    spec_args$tc.rate <- spec_args$monthlytcrate
    spec_args$monthlytcrate <- NULL
    spec_args$defva <- NULL
    spec_args$span.type <- spec_args$type
    spec_args$type <- NULL
    code <- paste0(
        "rjd3toolkit::set_outlier(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

rev_set_tradingdays <- function(x) {
    spec_args <- x$regarima$regression$td

    if (!is.null(spec_args$lpcoefficient)) {
        spec_args$leapyear.coef <- spec_args$lpcoefficient$value
        spec_args$leapyear.coef.type <- spec_args$lpcoefficient$type
    }
    spec_args$lpcoefficient <- NULL

    if (!is.null(spec_args$tdcoefficients)) {
        spec_args$coef <- as.numeric(spec_args$tdcoefficients[1L, ])
        if (!all(is.na(spec_args$coef)) && all(spec_args$coef == 0L)) {
            spec_args$coef <- NULL
        }
        spec_args$coef.type <- as.character(spec_args$tdcoefficients[2L, ])
    }
    spec_args$tdcoefficients <- NULL

    spec_args$calendar.name <- spec_args$holidays
    spec_args$holidays <- NULL

    spec_args$automatic <- switch(
        spec_args$auto,
        AUTO_NO = "UNUSED",
        gsub(
            x = spec_args$auto,
            pattern = "AUTO_",
            replacement = "",
            fixed = TRUE
        )
    )
    spec_args$auto <- NULL
    spec_args$option <- switch(
        spec_args$td,
        TD7 = "TradingDays",
        TD2 = "WorkingDays",
        gsub(x = spec_args$td, pattern = "TD_", replacement = "", fixed = TRUE)
    )
    spec_args$td <- NULL
    spec_args$leapyear <- spec_args$lp
    spec_args$lp <- NULL

    if (
        spec_args$option == "NONE" &&
            (length(spec_args$users) == 0L || is.null(spec_args$users)) &&
            !nzchar(spec_args$calendar.name) &&
            is.null(spec_args$coef)
    ) {
        spec_args$stocktd <- spec_args$w
    }
    spec_args$w <- NULL

    spec_args$uservariable <- spec_args$users
    spec_args$users <- NULL
    spec_args$ptest1 <- NULL
    spec_args$ptest2 <- NULL

    code <- paste0(
        "rjd3toolkit::set_tradingdays(\n\t",
        paste(
            names(spec_args),
            "=",
            keep_format(spec_args),
            collapse = ",\n\t"
        ),
        "\n)"
    )
    return(code)
}

#' @title Reverse Engineering of rjd3 Specifications
#'
#' @description
#' This family of functions reconstructs executable R code from a X13
#' specification object.
#' the generated code uses only the packages \{rjd3toolkit\} and \{rjd3x13\}.
#'
#' The main entry point is `rev_spec()`, which aggregates all reverse-generating
#'  helpers.
#'
#' @param x A JDemetra+ specification object
#'
#' @details
#'
#' The functions are taking a specification (argument `x` ) as input and returns
#'  A corresponding code that generates the object `x`.
#'
#' `rev_spec()` is the main function and calls all other helper functions
#' (`rev_XXX`). These helper functions (auxiliary functions) do NOT provide
#' sufficient code to reproduce the specification, but only the part dedicated
#' to them (outliers, trading days regressors, x11 filters, etc.).
#'
#' The generated code is neither unique nor optimal.
#'
#' That is, different codes (other than the one generated by rev_spec) can
#' generate the same specification.
#' It is not optimal because it does not use
#' the default values of the functions but clearly redefines all the parameters.
#'
#' @returns
#' Each `rev_XXX()` function returns a character string containing executable R
#' code.
#' `rev_spec()` returns a complete multi-line pipeline.
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#'
#' spec_init <- rjd3x13::x13_spec("RSA3") |>
#'     rjd3toolkit::set_basic(type = "All") |>
#'     rjd3toolkit::set_automodel(enabled = FALSE)
#' code <- rev_spec(spec_init)
#' cat(code)
#' spec_rebuilt <- eval(parse(text = code))
#'
#' @name translate-spec
#'
#' @export
rev_spec <- function(x) {
    code <- c(
        rev_add_outlier(x),
        rev_add_ramp(x),
        rev_add_usrdefvar(x),
        rev_set_x11(x),
        rev_set_automodel(x),
        rev_set_arima(x),
        rev_set_transform(x),
        rev_set_easter(x),
        rev_set_basic(x),
        rev_set_estimate(x),
        rev_set_outlier(x),
        rev_set_tradingdays(x),
        rev_set_benchmarking(x)
    ) |>
        paste(collapse = " |>\n") |>
        paste("rjd3x13::x13_spec() |>\n", ... = _) |>
        gsub(pattern = "\n", replacement = "\n\t", fixed = TRUE)

    return(code)
}
