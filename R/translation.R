
keep_format <- function(x) {
    if (is.list(x)) {
        output <- x |>
            lapply(FUN = keep_format)
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

    code <- paste0(
        "rjd3toolkit::add_outlier(",
        "\n\ttype = ", out_types,
        ",\n\tdate = ", out_dates,
        ",\n\tname = ", out_names,
        ",\n\tcoef = ", out_coeff,
        "\n)"
    )
    return(code)
}

rev_add_ramp <- function(x) {
    if (is.null(x$regarima$regression$ramps)) {
        return(NULL)
    }
    ramps <- x$regarima$regression$ramps
    ramp_start <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "start"
    ) |>
        deparse() |>
        paste0(collapse = "")
    ramp_end <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "end"
    ) |>
        deparse() |>
        paste0(collapse = "")
    ramp_names <- vapply(
        X = ramps,
        FUN = "[[",
        FUN.VALUE = character(1L),
        "name"
    ) |>
        deparse() |>
        paste0(collapse = "")
    ramp_coeff <- ramps |>
        lapply(FUN = "[[", "coef") |>
        lapply(FUN = "[[", "value") |>
        lapply(FUN = \(coeff) {
            if (is.null(coeff)) coeff <- 0L
            return(coeff)
        }) |>
        as.double() |>
        deparse() |>
        paste0(collapse = "")

    code <- paste0(
        "rjd3toolkit::add_ramp(",
        "\n\tstart = ", ramp_start,
        ",\n\tend = ", ramp_end,
        ",\n\tname = ", ramp_names,
        ",\n\tcoef = ", ramp_coeff,
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
    ) |> paste0(collapse = " |>\n")
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

rev_set_transform <- function(x) {
    nom_args <- names(x$regarima$transform)
    value_args <- x$regarima$transform

    nom_args[nom_args == "fn"] <- "fun"

    value_args[nom_args == "fun"] <- switch(
        value_args[nom_args == "fun"][[1L]],
        LEVEL = "NONE",
        value_args[nom_args == "fun"][[1L]]
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

rev_spec <- function(x) {
    code <- c(
        rev_add_outlier(x),
        rev_add_ramp(x),
        rev_add_usrdefvar(x),
        rev_set_x11(x),
        rev_set_transform(x),
        rev_set_easter(x),
        rev_set_basic(x),
        rev_set_estimate(x)
    ) |>
        paste(collapse = " |>\n") |>
        paste("rjd3x13::x13_spec() |>\n", ... = _) |>
        gsub(pattern = "\n", replacement = "\n\t")

    return(code)
}

