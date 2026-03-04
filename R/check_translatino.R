
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
#     val_mode <- sample(c(NA_character_, "Undefined", "Additive", "Multiplicative", "LogAdditive", "PseudoAdditive"), size = 1)
#     val_filter <- sample(c(NA_character_, "Msr", "Stable", "X11Default", "S3X1", "S3X3", "S3X5", "S3X9", "S3X15"), size = 1)
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
#     val_fun <- sample(c(NA_character_, "None", "Auto", "Log"), size = 1)
#     val_adjust <- sample(c(NA_character_, "None", "LeapYear", "LengthOfPeriod"), size = 1)
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
#     val_coef.type <- sample(c(NA_character_, "Estimated", "Fixed"), size = 1)
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
#     val_type <- sample(c(NA_character_, "All", "From", "To", "Between", "Last", "First", "Excluding"), size = 1)
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

# for (k in 1:100) {
#     val_type <- sample(c(NA_character_, "All", "From", "To", "Between", "Last", "First", "Excluding"), size = 1)
#     val_n0 <- sample(0:20, size = 1)
#     val_n1 <- sample(0:20, size = 1)
#     val_tol <- abs(rnorm(1, sd = 0.001))
#     val_exact.ml <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_unit.root.limit <- sample(c(NA, TRUE, FALSE), size = 1)
#     val_d0 <- as.Date(sample(20000, size = 1))
#     val_d1 <- as.Date(val_d0 + sample(20000, size = 1))
#
#     val_d0 <- as.character(val_d0)
#     val_d1 <- as.character(val_d1)
#
#     if (is.na(val_type)) {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "All") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "From") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 d0 = val_d0,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "To") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 d1 = val_d1,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "Between") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "Last") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 n1 = val_n1,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "First") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 n0 = val_n0,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else if (val_type == "Excluding") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_estimate(
#                 type = val_type,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 tol = val_tol,
#                 exact.ml = val_exact.ml,
#                 unit.root.limit = val_unit.root.limit
#             )
#     } else {
#         stop("weried")
#     }
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_estimate(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


# rev_add_usrdefvar
# for (k in 1:100) {
#
#     spec2 <- rjd3x13::x13_spec("RSA3")
#     nb_usrdefvar <- sample.int(10, size = 1)
#
#     for (j in seq_len(nb_usrdefvar)) {
#
#         val_group <- sample(c(0:9, letters), size = 3) |> paste0(collapse = "")
#         val_name <- sample(c(0:9, letters), size = 4) |> paste0(collapse = "")
#         val_label <- sample(c(0:9, letters), size = 5) |> paste0(collapse = "")
#         val_lag <- sample(0:20, size = 1)
#         val_coef <- rnorm(1)
#         val_regeffect <- c("Undefined", "Trend", "Seasonal", "Irregular", "Series",
#                            "SeasonallyAdjusted")
#         with_coef <- sample(c(T, F), size = 1)
#         with_label <- sample(c(T, F), size = 1)
#
#         if (with_coef && with_label) {
#             spec2 <- spec2 |>
#                 rjd3toolkit::add_usrdefvar(
#                     group = val_group,
#                     name = val_name,
#                     label = val_label,
#                     lag = val_lag,
#                     coef = val_coef,
#                     regeffect = val_regeffect
#                 )
#         } else if (with_coef) {
#             spec2 <- spec2 |>
#                 rjd3toolkit::add_usrdefvar(
#                     group = val_group,
#                     name = val_name,
#                     lag = val_lag,
#                     coef = val_coef,
#                     regeffect = val_regeffect
#                 )
#         } else if (with_label) {
#             spec2 <- spec2 |>
#                 rjd3toolkit::add_usrdefvar(
#                     group = val_group,
#                     name = val_name,
#                     label = val_label,
#                     lag = val_lag,
#                     regeffect = val_regeffect
#                 )
#         } else {
#             spec2 <- spec2 |>
#                 rjd3toolkit::add_usrdefvar(
#                     group = val_group,
#                     name = val_name,
#                     lag = val_lag,
#                     regeffect = val_regeffect
#                 )
#         }
#     }
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_add_usrdefvar(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


# rev_set_automodel
# for (k in 1:100) {
#
#     val_enabled <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_acceptdefault <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_cancel <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_ub1 <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_ub2 <- sample(c(NA, val_ub1 + abs(rnorm(1))), size = 1L)
#     val_reducecv <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_ljungboxlimit <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_tsig <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_ubfinal <- sample(c(NA, abs(rnorm(1))), size = 1L)
#     val_checkmu <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_mixed <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_balanced <- sample(c(TRUE, NA, FALSE), size = 1L)
#
#     spec2 <- rjd3x13::x13_spec("RSA3") |>
#         rjd3toolkit::set_automodel(
#             enabled = val_enabled,
#             acceptdefault = val_acceptdefault,
#             cancel = val_cancel,
#             ub1 = val_ub1,
#             ub2 = val_ub2,
#             reducecv = val_reducecv,
#             ljungboxlimit = val_ljungboxlimit,
#             tsig = val_tsig,
#             ubfinal = val_ubfinal,
#             checkmu = val_checkmu,
#             mixed = val_mixed,
#             balanced = val_balanced
#         )
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_automodel(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


# rev_set_arima
# for (k in 1:100) {
#     val_mean <- sample(c(NA, 0, -3:3), size = 1L)
#     val_mean.type <- sample(c(NA_character_, "Undefined", "Fixed", "Initial"), size = 1L)
#
#     val_p <- sample(c(NA, 0:5), size = 1L)
#     val_d <- sample(c(NA, 0:5), size = 1L)
#     val_q <- sample(c(NA, 0:5), size = 1L)
#     val_bp <- sample(c(NA, 0:5), size = 1L)
#     val_bd <- sample(c(NA, 0:5), size = 1L)
#     val_bq <- sample(c(NA, 0:5), size = 1L)
#
#     val_coef <- rnorm(sum(val_p, val_q, val_bp, val_bq, na.rm = TRUE))
#     val_coef.type <- sample(c(NA_character_, "Undefined", "Fixed", "Initial"), size = 1L)
#
#
#     spec2 <- rjd3x13::x13_spec("RSA3") |>
#         rjd3toolkit::set_arima(
#             mean = val_mean,
#             mean.type = val_mean.type,
#             p = val_p,
#             d = val_d,
#             q = val_q,
#             bp = val_bp,
#             bd = val_bd,
#             bq = val_bq,
#             coef = val_coef,
#             coef.type = val_coef.type
#         )
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_arima(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }

# rev_set_benchmarking
# for (k in 1:100) {
#
#     val_enabled <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_target <- sample(c(NA_character_, "CalendarAdjusted", "Original"), size = 1L)
#     val_rho <- sample(c(NA, runif(1)), size = 1L)
#     val_lambda <- sample(c(NA, runif(1)), size = 1L)
#     val_forecast <- sample(c(TRUE, NA, FALSE), size = 1L)
#     val_bias <- sample(c("None", "Additive", "Multiplicative"), size = 1L)
#
#     spec2 <- rjd3x13::x13_spec("RSA3") |>
#         rjd3toolkit::set_benchmarking(
#             enabled = val_enabled,
#             target = val_target,
#             rho = val_rho,
#             lambda = val_lambda,
#             forecast = val_forecast,
#             bias = val_bias
#         )
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_benchmarking(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }

# rev_set_outlier
# for (k in 1:100) {
#     val_span.type <- sample(c(NA_character_, "All", "From", "To", "Between", "Last", "First", "Excluding"), size = 1)
#
#     val_n0 <- sample(0:20, size = 1)
#     val_n1 <- sample(0:20, size = 1)
#     val_d0 <- as.Date(sample(20000, size = 1))
#     val_d1 <- as.Date(val_d0 + sample(20000, size = 1))
#     val_d0 <- as.character(val_d0)
#     val_d1 <- as.character(val_d1)
#
#     val_outliers.type <- sample(list(NA, sample(c("AO", "LS", "TC", "SO"), size = sample(4, size = 1))),
#                                 size = 1)[[1L]]
#     if (all(is.na(val_outliers.type))) {
#         val_critical.value <- NA
#     } else {
#         val_critical.value <- abs(rnorm(length(val_outliers.type)))
#     }
#
#     val_tc.rate <- sample(c(NA, abs(rnorm(1))), size = 1)
#     val_maxiter <- sample(c(NA, 1:60), size = 1)
#     val_lsrun <- sample(c(NA, 0:10), size = 1)
#     val_method <- sample(c(NA_character_, "AddOne", "AddAll"), size = 1)
#
#     if (is.na(val_span.type)) {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "All") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "From") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 d0 = val_d0,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "To") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 d1 = val_d1,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "Between") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 d0 = val_d0,
#                 d1 = val_d1,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "Last") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 n1 = val_n1,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "First") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 n0 = val_n0,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else if (val_span.type == "Excluding") {
#         spec2 <- rjd3x13::x13_spec("RSA3") |>
#             rjd3toolkit::set_outlier(
#                 span.type = val_span.type,
#                 n0 = val_n0,
#                 n1 = val_n1,
#                 outliers.type = val_outliers.type,
#                 critical.value = val_critical.value,
#                 tc.rate = val_tc.rate,
#                 maxiter = val_maxiter,
#                 lsrun = val_lsrun,
#                 method = val_method
#             )
#     } else {
#         stop("weried")
#     }
#
#     spec3 <- eval(
#         expr = parse(text = paste0(
#             "rjd3x13::x13_spec(\"RSA3\") |>\n",
#             rev_set_outlier(spec2)
#         )),
#         envir = .GlobalEnv
#     )
#     waldo::compare(
#         spec2,
#         spec3
#     ) |> print()
# }


# rev_set_tradingdays
for (k in 1:100) {

    val_option <- sample(c(NA_character_, "TradingDays", "WorkingDays", "TD2c", "TD3",
                           "TD3c", "TD4", "None", "UserDefined"), size = 1L)
    val_coef <- sample(list(NULL, NA_real_, runif(1)), size = 1L)[[1L]]
    val_stocktd <- NA_integer_
    val_uservariable <- sample(list(NULL, NA_character_, sample(c(0:9, letters), size = 4) |> paste0(collapse = "")), size = 1)[[1L]]
    if (is.na(val_option) || val_option == "None") {
        val_stocktd <- sample(0L:5L, size = 1L)
        val_coef <- NULL
        val_uservariable <- NULL
    } else if (!is.na(val_option) && val_option == "UserDefined") {
        val_uservariable <- sample(c(0:9, letters), size = 4) |> paste0(collapse = "")
    }

    val_test <- sample(c(NA_character_, "None", "Remove", "Add"), size = 1L)
    if (is.na(val_option) || val_option == "None") {
        val_test <- "None"
    }
    val_leapyear.coef <- sample(list(NULL, NA_real_, runif(1)), size = 1L)[[1L]]
    if (!is.null(val_coef) || !is.null(val_leapyear.coef)) {
        val_test <- "None"
    }

    val_calendar.name <- sample(c(NA_character_, sample(c(0:9, letters), size = 3) |> paste0(collapse = "")), size = 1)

    val_coef.type <- sample(c(NA_character_, "Fixed", "Estimated"), size = 1L)
    val_automatic <- sample(c(NA_character_, "Unused", "WaldTest", "Aic", "Bic"), size = 1L)
    val_autoadjust <- sample(c(NA, TRUE, FALSE), size = 1L)
    val_leapyear.coef.type <- sample(c(NA_character_, "Fixed", "Estimated"), size = 1L)
    val_leapyear <- sample(c(NA_character_, "LeapYear", "LengthOfPeriod", "None"), size = 1L)

    spec2 <- rjd3x13::x13_spec("RSA3") |>
        rjd3toolkit::set_tradingdays(
            option = val_option,
            calendar.name = val_calendar.name,
            uservariable = val_uservariable,
            stocktd = val_stocktd,
            test = val_test,
            coef = val_coef,
            coef.type = val_coef.type,
            automatic = val_automatic,
            autoadjust = val_autoadjust,
            leapyear = val_leapyear,
            leapyear.coef = val_leapyear.coef,
            leapyear.coef.type = val_leapyear.coef.type
        )


    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_tradingdays(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}
