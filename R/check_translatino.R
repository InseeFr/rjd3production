
spec1 <- rjd3x13::x13_spec(name = "RSA3")
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


# rev_set_x11
# for (k in 1:100) {
#     val_mode <- sample(c(NA, "Undefined", "Additive", "Multiplicative", "LogAdditive", "PseudoAdditive"), size = 1)
#     val_filter <- sample(c(NA, "Msr", "Stable", "X11Default", "S3X1", "S3X3", "S3X5", "S3X9", "S3X15"), size = 1)
#     val_calendar.sigma <- sample(c("None", "All", "Signif", "Select"), size = 1)
#     val_sigma.vector <- sample(list(integer(0), 1, 2), size = 1)
#
#     if (length(val_sigma.vector[[1L]]) == 0) {
#         spec2 <- spec1 |>
#             rjd3x13::set_x11(
#                 mode = val_mode,
#                 seasonal.comp = sample(c(NA, TRUE, FALSE), size = 1),
#                 seasonal.filter = val_filter,
#                 henderson.filter = sample(c(0, 2 * 1:50 + 1), size = 1),
#                 lsigma = runif(n = 1, 0.6, 3),
#                 usigma = runif(n = 1, 3, 10),
#                 bcasts = sample(0:30, size = 1),
#                 fcasts = sample(0:30, size = 1),
#                 calendar.sigma = val_calendar.sigma,
#                 exclude.forecast = sample(c(NA, TRUE, FALSE), size = 1)
#             )
#     } else {
#         spec2 <- spec1 |>
#             rjd3x13::set_x11(
#                 mode = val_mode,
#                 seasonal.comp = sample(c(NA, TRUE, FALSE), size = 1),
#                 seasonal.filter = val_filter,
#                 henderson.filter = sample(c(0, 2 * 1:50 + 1), size = 1),
#                 lsigma = runif(n = 1, 0.6, 3),
#                 usigma = runif(n = 1, 3, 10),
#                 bcasts = sample(0:30, size = 1),
#                 fcasts = sample(0:30, size = 1),
#                 calendar.sigma = val_calendar.sigma,
#                 sigma.vector = val_sigma.vector[[1L]],
#                 exclude.forecast = sample(c(NA, TRUE, FALSE), size = 1)
#             )
#     }
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec() |>\n",
#             rev_set_x11(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


# rev_add_ramp
spec2 <- spec1 |>
    rjd3toolkit::add_ramp(
        start = c("2020-01-01", "2018-10-01", "2010-02-01"),
        end = c("2020-02-01", "2019-10-01", "2010-05-01")
    ) |>
    rjd3toolkit::add_ramp(
        start = c("2021-11-01", "2022-03-01"),
        end = c("2022-01-01", "2022-05-01"),
        name = c("AO1TB", "AO2TB")
    ) |>
    rjd3toolkit::add_ramp(
        start = c("2012-01-01", "2024-12-01"),
        end = c("2015-01-01", "2025-12-01"),
        coef = c(0.58, 0.71)
    ) |>
    rjd3toolkit::add_ramp(
        start = c("2013-05-01", "2023-08-01"),
        end = c("2014-05-01", "2023-12-01"),
        coef = c(0.92, 0.23),
        name = c("LS1TB", "LS2TB")
    )

#rev_set_transform

# for (k in 1:100) {
#     val_fun <- sample(c(NA, "None", "Auto", "Log"), size = 1)
#     val_adjust <- sample(c(NA, "None", "LeapYear", "LengthOfPeriod"), size = 1)
#     val_out <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_aicdiff <- rnorm(n = 1)
#
#     spec2 <- spec1 |>
#         rjd3toolkit::set_transform(
#             fun = val_fun,
#             adjust = val_adjust,
#             outliers = val_out,
#             aicdiff = val_aicdiff
#         )
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec() |>\n",
#             rev_set_transform(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


#rev_set_easter

# for (k in 1:100) {
#     val_julian <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_duration <- sample(1:20, size = 1)
#     val_test <- sample(c("Add", "Remove", "None"), size = 1)
#     val_coef <- rnorm(n = 1)
#     val_coef.type <- sample(c(NA, "Estimated", "Fixed"), size = 1)
#     val_enabled <- sample(c(NA, TRUE, FALSE), size = 1)
#
#     spec2 <- rjd3x13::x13_spec("RSA3") |>
#         rjd3toolkit::set_easter(
#             enabled = val_enabled,
#             julian = val_julian,
#             duration = val_duration,
#             test = val_test,
#             coef = val_coef,
#             coef.type = val_coef.type
#         )
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_easter(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


#rev_set_basic

# for (k in 1:100) {
#     val_type <- sample(c(NA, "All", "From", "To", "Between", "Last", "First", "Excluding"), size = 1)
#     val_n0 <- sample(0:20, size = 1)
#     val_n1 <- sample(0:20, size = 1)
#     val_preprocessing <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_preliminary.check <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_d0 <- as.Date(sample(20000, size = 1))
#     val_d1 <- as.Date(val_d0 + sample(20000, size = 1))
#
#     val_d0 <- as.character(val_d0)
#     val_d1 <- as.character(val_d1)
#
#     if (is.na(val_type)) {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "All") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "From") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 d0 = val_d0,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "To") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 d1 = val_d1,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "Between") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "Last") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 n1 = val_n1,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "First") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 n0 = val_n0,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else if (val_type == "Excluding") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_basic(
#                 type = val_type,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 preliminary.check = val_preliminary.check,
#                 preprocessing = val_preprocessing
#             )
#     } else {
#         stop("weried")
#     }
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_basic(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }

#rev_set_estimate

for (k in 1:100) {
    val_type <- sample(c(NA, "All", "From", "To", "Between", "Last", "First", "Excluding"), size = 1)
    val_n0 <- sample(0:20, size = 1)
    val_n1 <- sample(0:20, size = 1)
    val_tol <- abs(rnorm(1, sd = 0.001))
    val_exact.ml <- sample(c(NA, TRUE, FALSE), size = 1)
    val_unit.root.limit <- sample(c(NA, TRUE, FALSE), size = 1)
    val_d0 <- as.Date(sample(20000, size = 1))
    val_d1 <- as.Date(val_d0 + sample(20000, size = 1))

    val_d0 <- as.character(val_d0)
    val_d1 <- as.character(val_d1)

    if (is.na(val_type)) {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                d0 = val_d0,
                d1 = val_d1,
                n0 = val_n0,
                n1 = val_n1,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "All") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "From") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                d0 = val_d0,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "To") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                d1 = val_d1,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "Between") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                d0 = val_d0,
                d1 = val_d1,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "Last") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                n1 = val_n1,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "First") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                n0 = val_n0,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else if (val_type == "Excluding") {
        spec2 <- rjd3x13::x13_spec("RSA3") |>
            rjd3toolkit::set_estimate(
                type = val_type,
                n0 = val_n0,
                n1 = val_n1,
                tol = val_tol,
                exact.ml = val_exact.ml,
                unit.root.limit = val_unit.root.limit
            )
    } else {
        stop("weried")
    }

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_estimate(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}
