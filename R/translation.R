
spec1 <- rjd3x13::x13_spec()
spec2 <- spec1 |>
    rjd3toolkit::add_outlier(
        type = c("AO", "LS", "TC", "SO"),
        date = c("2020-01-01", "2024-01-01", "2018-10-01", "2010-02-01")
    ) |>
    rjd3toolkit::add_outlier(
        type = c("AO", "AO"),
        date = c("2021-11-01", "2022-03-01"),
        name = c("AO1TB", "AO2TB")
    ) |>
    rjd3toolkit::add_outlier(
        type = c("TC", "TC"),
        date = c("2012-01-01", "2024-12-01"),
        coef = c(0.58, 0.71)
    ) |>
    rjd3toolkit::add_outlier(
        type = c("LS", "LS"),
        date = c("2013-05-01", "2023-08-01"),
        coef = c(0.92, 0.23),
        name = c("LS1TB", "LS2TB")
    )

keep_format <- function(x) {
    output <- x |>
        lapply(constructive::construct) |>
        lapply(base::`[[`, "code")
    return(output)
}

rev_add_outliers <- function(x) {
    if (is.null(x$regarima$regression$outliers)) {
        return(NULL)
    }
    outliers <- x$regarima$regression$outliers
    out_types <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "code"
    ) |>
        deparse() |>
        paste0(collapse = "")
    out_dates <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "pos"
    ) |>
        deparse() |>
        paste0(collapse = "")
    out_names <- vapply(
        X = outliers,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    ) |>
        deparse() |>
        paste0(collapse = "")
    out_coeff <- outliers |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = \(coeff) {
            if (is.null(coeff)) coeff <- 0L
            return(coeff)
        }) |>
        as.double() |>
        deparse() |>
        paste0(collapse = "")

    code <- paste(
        "rjd3toolkit::add_outlier(",
        "\n\ttype = ", out_types,
        "\n\tdate = ", out_dates,
        "\n\tname = ", out_names,
        "\n\tcoef = ", out_coeff,
        "\n)"
    )
    return(code)
}

rev_set_x11 <- function(x) {
    nom_args <- names(x$x11)
    value_args <- x$x11

    nom_args[nom_args == "lsig"] <- "lsigma"
    nom_args[nom_args == "usig"] <- "usigma"
    nom_args[nom_args == "nfcasts"] <- "fcasts"
    nom_args[nom_args == "nbcasts"] <- "bcasts"
    nom_args[nom_args == "seasonal"] <- "seasonal.comp"
    nom_args[nom_args == "henderson"] <- "henderson.filter"
    nom_args[nom_args == "sfilters"] <- "seasonal.filter"
    nom_args[nom_args == "sigma"] <- "calendar.sigma"
    nom_args[nom_args == "vsigmas"] <- "sigma.vector"
    nom_args[nom_args == "excludefcasts"] <- "exclude.forecast"

    value_args[nom_args == "mode"] <- switch(
        value_args[nom_args == "mode"][[1L]],
        UNKNOWN = "UNDEFINED",
        value_args[nom_args == "mode"][[1L]]
    )
    value_args[nom_args == "seasonal.filter"] <- gsub(
        pattern = "FILTER_",
        replacement = "",
        value_args[nom_args == "seasonal.filter"][[1L]]
    )
    value_args[nom_args == "bias"] <- switch(
        value_args[nom_args == "bias"][[1L]],
        RATIO = NA,
        value_args[nom_args == "bias"][[1L]]
    )
    if (length(value_args[nom_args == "sigma.vector"][[1L]]) == 0L) {
        value_args[nom_args == "sigma.vector"] <- NULL
        nom_args <- nom_args[nom_args != "sigma.vector"]
    }

    code <- paste0(
        "rjd3x13::set_x11(\n\t",
        paste(nom_args, "=", keep_format(value_args), collapse = ",\n\t"),
        "\n)"
    )
    return(code)
}


for (k in 1:100) {
    val_mode <- sample(c(NA, "Undefined", "Additive", "Multiplicative", "LogAdditive", "PseudoAdditive"), size = 1)
    val_filter <- sample(c(NA, "Msr", "Stable", "X11Default", "S3X1", "S3X3", "S3X5", "S3X9", "S3X15"), size = 1)
    val_calendar.sigma <- sample(c("None", "All", "Signif", "Select"), size = 1)
    val_sigma.vector <- sample(list(integer(0), 1, 2), size = 1)

    if (length(val_sigma.vector[[1L]]) == 0) {
        spec2 <- spec1 |>
            rjd3x13::set_x11(
                mode = val_mode,
                seasonal.comp = sample(c(NA, TRUE, FALSE), size = 1),
                seasonal.filter = val_filter,
                henderson.filter = sample(c(0, 2 * 1:50 + 1), size = 1),
                lsigma = runif(n = 1, 0.6, 3),
                usigma = runif(n = 1, 3, 10),
                bcasts = sample(0:30, size = 1),
                fcasts = sample(0:30, size = 1),
                calendar.sigma = val_calendar.sigma,
                exclude.forecast = sample(c(NA, TRUE, FALSE), size = 1)
            )
    } else {
        spec2 <- spec1 |>
            rjd3x13::set_x11(
                mode = val_mode,
                seasonal.comp = sample(c(NA, TRUE, FALSE), size = 1),
                seasonal.filter = val_filter,
                henderson.filter = sample(c(0, 2 * 1:50 + 1), size = 1),
                lsigma = runif(n = 1, 0.6, 3),
                usigma = runif(n = 1, 3, 10),
                bcasts = sample(0:30, size = 1),
                fcasts = sample(0:30, size = 1),
                calendar.sigma = val_calendar.sigma,
                sigma.vector = val_sigma.vector[[1L]],
                exclude.forecast = sample(c(NA, TRUE, FALSE), size = 1)
            )
    }
    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec() |>\n",
            rev_set_x11(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}


# rev_add_outliers(spec2) |> cat()

rev_set_x11(spec1) |> cat()



waldo::compare(spec1, spec3)
