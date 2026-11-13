random_flag <- function() {
    random_choice(x = c(NA, TRUE, FALSE))
}

#' @importFrom checkmate assert_count
random_name <- function(n = n) {
    checkmate::assert_count(n)

    nom <- paste(
        sample(x = c(0L:9L, letters), size = n, replace = TRUE),
        collapse = ""
    )
    return(nom)
}

#' @importFrom checkmate assert_vector
random_choice <- function(x) {
    checkmate::assert_vector(x)

    sample(x = x, size = 1L)
}

#' @importFrom stats runif
random_numeric_or_null <- function() {
    random_choice(list(NULL, NA_real_, stats::runif(1L)))[[1L]]
}

random_span <- function() {
    out <- list()

    out$type <- random_choice(c(
        NA_character_,
        "All",
        "From",
        "To",
        "Between",
        "Last",
        "First",
        "Excluding"
    ))
    val_n0 <- random_choice(0L:20L)
    val_n1 <- random_choice(0L:20L)
    val_d0 <- base::as.Date(
        sample.int(15000L, size = 1L),
        origin = "1970-01-01"
    )
    val_d1 <- base::as.Date(
        val_d0 + sample.int(5000L, size = 1L),
        origin = "1970-01-01"
    )
    if (is.na(out$type)) {
        out$d0 <- format(val_d0)
        out$d1 <- format(val_d1)
        out$n0 <- val_n0
        out$n1 <- val_n1
    } else if (out$type == "From") {
        out$d0 <- format(val_d0)
    } else if (out$type == "To") {
        out$d1 <- format(val_d1)
    } else if (out$type == "Between") {
        out$d0 <- format(val_d0)
        out$d1 <- format(val_d1)
    } else if (out$type == "Last") {
        out$n1 <- val_n1
    } else if (out$type == "First") {
        out$n0 <- val_n0
    } else if (out$type == "Excluding") {
        out$n0 <- val_n0
        out$n1 <- val_n1
    }

    return(out)
}

#' @importFrom rjd3toolkit add_outlier
#' @importFrom stats rnorm
random_add_outlier <- function(x) {
    spec_args <- list(x = x)

    n <- sample.int(15L, size = 1L)
    spec_args$type <- sample(
        c("AO", "LS", "TC", "SO"),
        size = n,
        replace = TRUE
    )
    spec_args$date <- as.character(base::as.Date(
        sample.int(20000L, size = n),
        origin = "1970-01-01"
    ))
    spec_args$coef <- sample(c(rep(0.0, n), stats::rnorm(n)), size = n)
    spec_args$name <- sample(
        x = c(
            paste0(spec_args$type, " (", spec_args$date, ")"),
            paste0(spec_args$type, seq_len(n), "_rnd")
        ),
        size = n
    )

    output <- do.call(rjd3toolkit::add_outlier, spec_args)
    return(output)
}

#' @importFrom rjd3x13 set_x11
#' @importFrom stats runif
random_set_x11 <- function(x) {
    spec_args <- list(x = x)

    spec_args$mode <- random_choice(c(
        NA_character_,
        "Undefined",
        "Additive",
        "Multiplicative",
        "LogAdditive",
        "PseudoAdditive"
    ))
    spec_args$seasonal.comp <- random_flag()
    spec_args$seasonal.filter <- random_choice(c(
        NA_character_,
        "Msr",
        "Stable",
        "X11Default",
        "S3X1",
        "S3X3",
        "S3X5",
        "S3X9",
        "S3X15"
    ))
    spec_args$henderson.filter <- random_choice(c(0L, 2L * seq_len(25L) + 1L))
    spec_args$lsigma <- stats::runif(n = 1L, 0.6, 3.0)
    spec_args$usigma <- stats::runif(n = 1L, 3.0, 10.0)
    spec_args$bcasts <- random_choice(0L:30L)
    spec_args$fcasts <- random_choice(0L:30L)
    spec_args$calendar.sigma <- random_choice(c(
        "None",
        "All",
        "Signif",
        "Select"
    ))
    spec_args$exclude.forecast <- random_flag()
    if (spec_args$calendar.sigma == "Select") {
        spec_args$sigma.vector <- random_choice(list(1L, 2L))[[1L]]
    } else {
        spec_args$sigma.vector <- random_choice(list(NULL, 1L, 2L))[[1L]]
    }

    output <- do.call(rjd3x13::set_x11, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_transform
random_set_transform <- function(x) {
    spec_args <- list(x = x)

    spec_args$fun <- random_choice(c(NA_character_, "None", "Auto", "Log"))
    spec_args$adjust <- random_choice(c(
        NA_character_,
        "None",
        "LeapYear",
        "LengthOfPeriod"
    ))
    spec_args$outliers <- random_flag()
    spec_args$aicdiff <- random_numeric_or_null()

    output <- do.call(rjd3toolkit::set_transform, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_easter
random_set_easter <- function(x) {
    spec_args <- list(x = x)

    spec_args$enabled <- random_flag()
    spec_args$julian <- random_flag()
    spec_args$duration <- random_choice(1L:20L)
    spec_args$test <- random_choice(c("Add", "Remove", "None"))
    spec_args$coef <- random_numeric_or_null()

    if (
        spec_args$test %in%
            c("Add", "Remove") &&
            !is.na(spec_args$coef) &&
            !is.null(spec_args$coef)
    ) {
        spec_args$coef.type <- "Estimated"
    } else {
        spec_args$coef.type <- random_choice(c(
            NA_character_,
            "Estimated",
            "Fixed"
        ))
    }

    output <- do.call(rjd3toolkit::set_easter, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_tradingdays
#' @importFrom stats runif
random_set_tradingdays <- function(x) {
    spec_args <- list(x = x)

    spec_args$option <- random_choice(c(
        NA_character_,
        "TradingDays",
        "WorkingDays",
        "TD2c",
        "TD3",
        "TD3c",
        "TD4",
        "None",
        "UserDefined"
    ))

    spec_args$coef <- random_choice(list(NULL, NA_real_, stats::runif(1L)))[[
        1L
    ]]
    spec_args$leapyear.coef <- random_choice(list(
        NULL,
        NA_real_,
        stats::runif(1L)
    ))[[1L]]
    spec_args$test <- random_choice(c(NA_character_, "None", "Remove", "Add"))

    if (is.na(spec_args$option) || spec_args$option == "None") {
        spec_args$stocktd <- random_choice(list(
            NA_integer_,
            NULL,
            0L,
            1L,
            2L
        ))[[1L]]
        spec_args$test <- "None"
        spec_args$coef <- NULL
        spec_args$calendar.name <- NA_character_
    } else if (spec_args$option == "UserDefined") {
        spec_args$uservariable <- random_name(6L)
        spec_args$calendar.name <- random_choice(c(
            NA_character_,
            "calA",
            "calB"
        ))
    } else {
        spec_args$calendar.name <- random_choice(c(
            NA_character_,
            "calA",
            "calB"
        ))
    }

    if (!is.null(spec_args$coef) || !is.null(spec_args$leapyear.coef)) {
        spec_args$test <- "None"
    }

    spec_args$coef.type <- random_choice(c(NA_character_, "Fixed", "Estimated"))
    spec_args$automatic <- random_choice(c(
        NA_character_,
        "Unused",
        "WaldTest",
        "Aic",
        "Bic"
    ))
    spec_args$autoadjust <- random_flag()
    spec_args$leapyear <- random_choice(c(
        NA_character_,
        "LeapYear",
        "LengthOfPeriod",
        "None"
    ))
    spec_args$leapyear.coef.type <- random_choice(c(
        NA_character_,
        "Fixed",
        "Estimated"
    ))

    output <- do.call(rjd3toolkit::set_tradingdays, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_arima
#' @importFrom stats rnorm
random_set_arima <- function(x) {
    spec_args <- list(x = x)

    spec_args$mean <- random_choice(c(NA_integer_, 0L, -2L:2L))
    spec_args$mean.type <- random_choice(c(
        NA_character_,
        "Undefined",
        "Fixed",
        "Initial"
    ))
    spec_args$p <- random_choice(c(NA_integer_, 0L:3L))
    spec_args$d <- random_choice(c(NA_integer_, 0L:2L))
    spec_args$q <- random_choice(c(NA_integer_, 0L:3L))
    spec_args$bp <- random_choice(c(NA_integer_, 0L:2L))
    spec_args$bd <- random_choice(c(NA_integer_, 0L:2L))
    spec_args$bq <- random_choice(c(NA_integer_, 0L:2L))
    spec_args$coef <- random_choice(list(
        NULL,
        stats::rnorm(sum(
            spec_args$p,
            spec_args$q,
            spec_args$bp,
            spec_args$bq,
            na.rm = TRUE
        ))
    ))[[1L]]
    spec_args$coef.type <- random_choice(c(
        NA_character_,
        "Undefined",
        "Fixed",
        "Initial"
    ))

    output <- do.call(rjd3toolkit::set_arima, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_automodel
#' @importFrom stats rnorm
random_set_automodel <- function(x) {
    spec_args <- list(x = x)

    spec_args$enabled <- random_flag()
    spec_args$acceptdefault <- random_flag()
    spec_args$cancel <- random_choice(c(
        NA,
        stats::runif(n = 1L, min = 0.0, max = 0.2)
    ))
    spec_args$ub1 <- random_choice(c(NA, 1.0 + abs(stats::rnorm(1L))))
    spec_args$ub2 <- random_choice(c(NA, 1.0 + abs(stats::rnorm(1L))))
    spec_args$reducecv <- random_choice(c(
        NA,
        stats::runif(n = 1L, min = 0.05, max = 0.3)
    ))
    spec_args$ljungboxlimit <- random_choice(c(NA, abs(stats::rnorm(1L))))
    spec_args$tsig <- random_choice(c(NA, 0.5 + abs(stats::rnorm(1L))))
    spec_args$ubfinal <- random_choice(c(NA, 1.0 + abs(stats::rnorm(1L))))
    spec_args$checkmu <- random_flag()
    spec_args$mixed <- random_flag()
    spec_args$balanced <- random_flag()

    output <- do.call(rjd3toolkit::set_automodel, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_benchmarking
random_set_benchmarking <- function(x) {
    spec_args <- list(x = x)

    spec_args$enabled <- random_flag()
    spec_args$target <- random_choice(c(
        NA_character_,
        "CalendarAdjusted",
        "Original"
    ))
    spec_args$rho <- random_numeric_or_null()
    spec_args$lambda <- random_numeric_or_null()
    spec_args$forecast <- random_flag()
    spec_args$bias <- random_choice(c("None", "Additive", "Multiplicative"))

    output <- do.call(rjd3toolkit::set_benchmarking, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit add_ramp
#' @importFrom stats rnorm
random_add_ramp <- function(x) {
    spec_args <- list(x = x)

    n <- sample.int(15L, size = 1L)
    spec_args$start <- sample.int(18000L, size = n)
    spec_args$end <- spec_args$start + sample.int(2000L, size = n)
    spec_args$start <- as.character(base::as.Date(
        spec_args$start,
        origin = "1970-01-01"
    ))
    spec_args$end <- as.character(base::as.Date(
        spec_args$end,
        origin = "1970-01-01"
    ))
    spec_args$coef <- sample(c(rep(0.0, n), stats::rnorm(n)), size = n)
    spec_args$name <- sample(
        x = c(
            paste0(spec_args$type, " (", spec_args$date, ")"),
            paste0("Ramp", seq_len(n), "_rnd")
        ),
        size = n
    )

    output <- do.call(rjd3toolkit::add_ramp, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit set_basic
random_set_basic <- function(x) {
    spec_args <- list(x = x)

    spec_args <- c(spec_args, random_span())
    spec_args$preliminary.check <- random_flag()
    spec_args$preprocessing <- random_flag()

    output <- do.call(rjd3toolkit::set_basic, spec_args)
    return(output)
}

#' @importFrom stats runif
#' @importFrom rjd3toolkit set_estimate
random_set_estimate <- function(x) {
    spec_args <- list(x = x)

    spec_args <- c(spec_args, random_span())
    spec_args$tol <- random_choice(list(
        NULL,
        NA_real_,
        abs(stats::runif(1L))
    ))[[1L]]
    spec_args$exact.ml <- random_flag()
    spec_args$unit.root.limit <- random_flag()

    output <- do.call(rjd3toolkit::set_estimate, spec_args)
    return(output)
}

#' @importFrom stats rnorm
#' @importFrom rjd3toolkit set_outlier
random_set_outlier <- function(x) {
    spec_args <- list(x = x)

    spec_args <- c(spec_args, random_span())
    spec_args$span.type <- spec_args$type
    spec_args$type <- NULL
    spec_args$outliers.type <- random_choice(list(
        NA,
        sample(
            c("AO", "LS", "TC", "SO"),
            size = random_choice(seq_len(4L)),
            replace = FALSE
        )
    ))[[1L]]
    if (!anyNA(spec_args$outliers.type)) {
        spec_args$critical.value <- random_choice(list(
            NA,
            NULL,
            abs(stats::rnorm(length(spec_args$outliers.type)))
        ))[[1L]]
    }
    spec_args$tc.rate <- random_choice(c(
        NA,
        abs(random_choice(seq(0.1, 1.0, length.out = 200L)))
    ))
    spec_args$maxiter <- random_choice(c(NA, 1L:60L))
    spec_args$lsrun <- random_choice(c(NA, 0L:10L))
    spec_args$method <- random_choice(c(NA_character_, "AddOne", "AddAll"))

    output <- do.call(rjd3toolkit::set_outlier, spec_args)
    return(output)
}

#' @importFrom rjd3toolkit add_usrdefvar
#' @importFrom stats rnorm
random_add_usrdefvar <- function(x) {
    output <- x

    nb_usrdefvar <- random_choice(1L:10L)
    for (j in seq_len(nb_usrdefvar)) {
        spec_args <- list(x = output)

        spec_args$group <- random_name(3L)
        spec_args$name <- random_name(4L)
        spec_args$lag <- random_choice(0L:20L)
        spec_args$regeffect <- random_choice(c(
            "Undefined",
            "Trend",
            "Seasonal",
            "Irregular",
            "Series",
            "SeasonallyAdjusted"
        ))

        spec_args$coef <- random_choice(list(NULL, stats::rnorm(1L)))[[1L]]
        spec_args$label <- random_choice(list(NULL, random_name(5L)))[[1L]]

        output <- do.call(rjd3toolkit::add_usrdefvar, spec_args)
    }

    return(output)
}

#' @title Random JDemetra+ Specifications Generator
#'
#' @description
#' `random_spec()` allows you to create a random specification based on a set
#' of helper functions (auxiliary functions).
#' These specifications are created from scratch.
#'
#' @details
#' The objective is to enable:
#'
#' * examples
#' * tests of other functions (notably for reverse engineering)
#' * other tests and demonstrations
#'
#' @returns a JD+ Specification
#'
#' @examplesIf rjd3jars::check_java_version(silent = TRUE)
#' set.seed(1L)
#' spec <- random_spec()
#'
#' @name random-spec
#' @export
#' @importFrom rjd3x13 x13_spec
#'
random_spec <- function() {
    output <- rjd3x13::x13_spec("RSA3") |>
        random_add_outlier() |>
        random_add_ramp() |>
        random_add_usrdefvar() |>
        random_set_x11() |>
        random_set_automodel() |>
        random_set_arima() |>
        random_set_transform() |>
        random_set_easter() |>
        random_set_basic() |>
        random_set_estimate() |>
        random_set_outlier() |>
        random_set_tradingdays() |>
        random_set_benchmarking()

    return(output)
}
