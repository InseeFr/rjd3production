
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


# rev_add_outliers(spec2) |> cat()

# rev_set_x11(spec1) |> cat()

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

spec3 <- spec1 |>
    rjd3toolkit::add_ramp(
        start = c("2020-01-01", "2018-10-01", "2010-02-01", "2021-11-01", "2022-03-01", "2012-01-01", "2024-12-01", "2013-05-01", "2023-08-01"),
        end = c("2020-02-01", "2019-10-01", "2010-05-01", "2022-01-01", "2022-05-01", "2015-01-01", "2025-12-01", "2014-05-01", "2023-12-01"),
        name = c("rp.2020-01-01 - 2020-02-01", "rp.2018-10-01 - 2019-10-01", "rp.2010-02-01 - 2010-05-01", "AO1TB", "AO2TB", "rp.2012-01-01 - 2015-01-01", "rp.2024-12-01 - 2025-12-01", "LS1TB", "LS2TB"),
        coef = c(0, 0, 0, 0, 0, 0.58, 0.71, 0.92, 0.23)
    )
waldo::compare(spec3, spec2)
