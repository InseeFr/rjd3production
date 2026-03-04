random_flag <- function() sample(c(NA, TRUE, FALSE), 1)

random_choice <- function(x) sample(x, 1)

random_numeric_or_null <- function() {
    sample(list(NULL, NA_real_, runif(1)), 1)[[1]]
}

random_add_outlier <- function(x) {
    args <- list(x = x)
    n <- sample.int(15L, size = 1L)
    args$type <- sample(c("AO", "LS", "TC", "SO"), size = n, replace = TRUE)
    args$date <- as.character(as.Date(sample.int(20000, size = n)))
    args$coef <- sample(c(rep(0.0, n), rnorm(n)), size = n)
    args$name <- sample(
        x = c(
            paste0(args$type, " (", args$date, ")"),
            paste0(args$type, seq_len(n), "_rnd")
        ),
        size = n
    )
    output <- do.call(rjd3toolkit::add_outlier, args)
    return(output)
}

random_set_x11 <- function(x) {
    args <- list(x = x)

    args$mode <- random_choice(c(
        NA_character_,
        "Undefined",
        "Additive",
        "Multiplicative",
        "LogAdditive",
        "PseudoAdditive"
    ))
    args$seasonal.comp <- random_flag()
    args$seasonal.filter <- random_choice(c(
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
    args$henderson.filter <- random_choice(c(0, 2 * (1:25) + 1))
    args$lsigma <- runif(1, 0.6, 3)
    args$usigma <- runif(1, 3, 10)
    args$bcasts <- random_choice(0:30)
    args$fcasts <- random_choice(0:30)
    args$calendar.sigma <- random_choice(c("None", "All", "Signif", "Select"))
    args$exclude.forecast <- random_flag()

    val_sigma.vector <- sample(list(integer(0), 1L, 2L), 1)[[1]]
    if (length(val_sigma.vector) > 0) {
        args$sigma.vector <- val_sigma.vector
    }

    output <- do.call(rjd3x13::set_x11, args)
    return(output)
}

random_set_transform <- function(x) {
    args <- list(x = x)

    args$fun <- random_choice(c(NA_character_, "None", "Auto", "Log"))
    args$adjust <- random_choice(c(
        NA_character_,
        "None",
        "LeapYear",
        "LengthOfPeriod"
    ))
    args$outliers <- random_flag()
    args$aicdiff <- rnorm(1)

    output <- do.call(rjd3toolkit::set_transform, args)
    return(output)
}
