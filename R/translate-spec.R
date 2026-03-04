keep_format <- function(x) {
    if (is.list(x)) {
        output <- x |>
            lapply(FUN = keep_format) |>
            lapply(FUN = paste0, collapse = "\n\t")
    } else {
        output <- x |>
            constructive::construct() |>
            base::`[[`("code")
    }
    return(output)
}

rev_add_outlier <- function(x) {
    if (is.null(x$regarima$regression$outliers)) {
        return(NULL)
    }
    args <- list()
    outliers <- x$regarima$regression$outliers

    args$type <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "code"
    )
    args$dates <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "pos"
    )
    args$names <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    )
    args$coef <- outliers |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = \(coeff) {
            if (is.null(coeff)) {
                coeff <- 0L
            }
            return(coeff)
        }) |>
        as.double()

    code <- paste0(
        "rjd3toolkit::add_outlier(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_add_ramp <- function(x) {
    if (is.null(x$regarima$regression$ramps)) {
        return(NULL)
    }
    args <- list()
    ramps <- x$regarima$regression$ramps

    args$start <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "start"
    )
    args$end <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "end"
    )
    args$names <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    )
    args$coef <- ramps |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = \(coeff) {
            if (is.null(coeff)) {
                coeff <- 0L
            }
            return(coeff)
        }) |>
        as.double()

    code <- paste0(
        "rjd3toolkit::add_ramp(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_one_usrdefvar <- function(args) {
    args$label <- args$name

    group_name <- strsplit(x = args$id, split = ".", fixed = TRUE)[[1L]]
    args$group <- group_name[1L]
    args$name <- group_name[2L]
    args$id <- NULL

    if (!is.null(args$coef)) {
        args$coef <- args$coef$value
    }

    code <- paste0(
        "rjd3toolkit::add_usrdefvar(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
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
        paste0(collapse = " |>\n")
    return(code)
}

rev_set_x11 <- function(x) {
    args <- x$x11

    args$lsigma <- args$lsig
    args$lsig <- NULL
    args$usigma <- args$usig
    args$usig <- NULL
    args$fcasts <- args$nfcasts
    args$nfcasts <- NULL
    args$bcasts <- args$nbcasts
    args$nbcasts <- NULL
    args$seasonal.comp <- args$seasonal
    args$seasonal <- NULL
    args$henderson.filter <- args$henderson
    args$henderson <- NULL
    args$seasonal.filter <- args$sfilters
    args$sfilters <- NULL
    args$calendar.sigma <- args$sigma
    args$sigma <- NULL
    args$sigma.vector <- args$vsigmas
    args$vsigmas <- NULL
    args$exclude.forecast <- args$excludefcasts
    args$excludefcasts <- NULL

    args$mode <- switch(
        args$mode,
        UNKNOWN = "UNDEFINED",
        args$mode
    )
    args$seasonal.filter <- gsub(
        pattern = "FILTER_",
        replacement = "",
        args$seasonal.filter
    )
    args$bias <- switch(
        args$bias,
        RATIO = NA,
        args$bias
    )
    if (length(args$sigma.vector) == 0L) {
        args$sigma.vector <- NULL
    }

    code <- paste0(
        "rjd3x13::set_x11(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_transform <- function(x) {
    nom_args <- names(x$regarima$transform)
    value_args <- x$regarima$transform

    nom_args[nom_args == "fn"] <- "fun"

    value_args[nom_args == "fun"] <- switch(
        value_args[nom_args == "fun"],
        LEVEL = "NONE",
        value_args[nom_args == "fun"]
    )
    code <- paste0(
        "rjd3toolkit::set_transform(\n\t",
        paste(nom_args, "=", keep_format(value_args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_easter <- function(x) {
    args <- x$regarima$regression$easter
    args$enabled <- toupper(args$type) != "UNUSED"
    if (args$type == "JULIAN") {
        args$julian <- TRUE
    }

    args$type <- NULL

    if (!is.null(args$coefficient)) {
        args$coef <- args$coefficient$value
        args$coef.type <- args$coefficient$type
    }
    args$coefficient <- NULL
    code <- paste0(
        "rjd3toolkit::set_easter(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_basic <- function(x) {
    args <- c(x$regarima$basic, x$regarima$basic$span)
    args$span <- NULL
    names(args)[names(args) == "preliminaryCheck"] <- "preliminary.check"
    code <- paste0(
        "rjd3toolkit::set_basic(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_estimate <- function(x) {
    args <- c(x$regarima$estimate, x$regarima$estimate$span)
    args$span <- NULL
    code <- paste0(
        "rjd3toolkit::set_estimate(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_automodel <- function(x) {
    args <- x$regarima$automodel
    args$acceptdefault <- args$acceptdef
    args$acceptdef <- NULL
    args$ljungboxlimit <- args$ljungbox
    args$ljungbox <- NULL
    args$reducecv <- args$predcv
    args$predcv <- NULL
    args$fct <- NULL
    code <- paste0(
        "rjd3toolkit::set_automodel(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_arima <- function(x) {
    args <- c(x$regarima$arima, x$regarima$regression$mean)
    args$mean <- args$value
    args$value <- NULL
    args$mean.type <- args$type
    args$type <- NULL
    if ("phi" %in% names(args) && is.null(args$phi)) {
        args$p <- NULL
    } else if (is.null(args$phi)) {
        args$p <- 0
    } else {
        args$p <- ncol(args$phi)
        args$coef <- c(args$coef, as.numeric(args$phi[1L, ]))
        args$coef.type <- c(args$coef.type, as.character(args$phi[2L, ]))
    }
    if ("theta" %in% names(args) && is.null(args$theta)) {
        args$q <- NULL
    } else if (is.null(args$theta)) {
        args$q <- 0
    } else {
        args$q <- ncol(args$theta)
        args$coef <- c(args$coef, as.numeric(args$theta[1L, ]))
        args$coef.type <- c(args$coef.type, as.character(args$theta[2L, ]))
    }
    if ("bphi" %in% names(args) && is.null(args$bphi)) {
        args$bp <- NULL
    } else if (is.null(args$bphi)) {
        args$bp <- 0
    } else {
        args$bp <- ncol(args$bphi)
        args$coef <- c(args$coef, as.numeric(args$bphi[1L, ]))
        args$coef.type <- c(args$coef.type, as.character(args$bphi[2L, ]))
    }
    if ("btheta" %in% names(args) && is.null(args$btheta)) {
        args$bq <- NULL
    } else if (is.null(args$btheta)) {
        args$bq <- 0
    } else {
        args$bq <- ncol(args$btheta)
        args$coef <- c(args$coef, as.numeric(args$btheta[1L, ]))
        args$coef.type <- c(args$coef.type, as.character(args$btheta[2L, ]))
    }
    args$phi <- NULL
    args$theta <- NULL
    args$bphi <- NULL
    args$btheta <- NULL
    args$period <- NULL
    code <- paste0(
        "rjd3toolkit::set_arima(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_benchmarking <- function(x) {
    args <- x$benchmarking
    if (!is.null(args$target)) {
        args$target <- switch(
            args$target,
            TARGET_CALENDARADJUSTED = "CALENDARADJUSTED",
            TARGET_ORIGINAL = "ORIGINAL",
            NA
        )
    }
    if (!is.null(args$bias)) {
        args$bias <- switch(
            args$bias,
            BIAS_MULTIPLICATIVE = "MULTIPLICATIVE",
            BIAS_ADDITIVE = "ADDITIVE",
            BIAS_NONE = "NONE",
            NA
        )
    }
    code <- paste0(
        "rjd3toolkit::set_benchmarking(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_outlier <- function(x) {
    args <- c(x$regarima$outlier, x$regarima$outlier$span)
    args$outliers.type <- vapply(
        X = args$outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "type"
    )
    args$critical.value <- vapply(
        X = args$outliers,
        FUN = "[[",
        FUN.VALUE = numeric(1L),
        "va"
    )
    args$outliers <- NULL
    args$span <- NULL
    args$tc.rate <- args$monthlytcrate
    args$monthlytcrate <- NULL
    args$defva <- NULL
    args$span.type <- args$type
    args$type <- NULL
    code <- paste0(
        "rjd3toolkit::set_outlier(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

rev_set_tradingdays <- function(x) {
    args <- x$regarima$regression$td

    if (!is.null(args$lpcoefficient)) {
        args$leapyear.coef <- args$lpcoefficient$value
        args$leapyear.coef.type <- args$lpcoefficient$type
    }
    args$lpcoefficient <- NULL

    if (!is.null(args$tdcoefficients)) {
        args$coef <- as.numeric(args$tdcoefficients[1L, ])
        if (!all(is.na(args$coef)) && all(args$coef == 0)) {
            args$coef <- NULL
        }
        args$coef.type <- as.character(args$tdcoefficients[2L, ])
    }
    args$tdcoefficients <- NULL

    args$automatic <- switch(
        args$auto,
        AUTO_NO = "UNUSED",
        gsub(x = args$auto, pattern = "AUTO_", replacement = "", fixed = TRUE)
    )
    args$auto <- NULL
    args$option <- switch(
        args$td,
        TD7 = "TradingDays",
        TD2 = "WorkingDays",
        gsub(x = args$td, pattern = "TD_", replacement = "", fixed = TRUE)
    )
    args$td <- NULL
    args$leapyear <- args$lp
    args$lp <- NULL

    if (
        args$option == "NONE" &&
            (length(args$users) == 0L || is.null(args$users)) &&
            is.null(args$coef)
    ) {
        args$stocktd <- args$w
    }
    args$w <- NULL

    args$uservariable <- args$users
    args$users <- NULL
    args$ptest1 <- NULL
    args$ptest2 <- NULL

    args$calendar.name <- args$holidays
    args$holidays <- NULL

    code <- paste0(
        "rjd3toolkit::set_tradingdays(\n\t",
        paste(names(args), "=", keep_format(args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}

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
        gsub(pattern = "\n", replacement = "\n\t")

    return(code)
}
