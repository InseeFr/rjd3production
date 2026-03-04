# rev_set_x11
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_add_outlier()

    spec3 <- eval(
        expr = parse(
            text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_add_outlier(spec2)
            )
        ),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |>
        print()
}


# rev_set_x11
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_x11()

    spec3 <- eval(
        expr = parse(
            text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_x11(spec2)
            )
        ),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |>
        print()
}


# rev_add_ramp
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_add_ramp()

    spec3 <- eval(
        expr = parse(
            text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_add_ramp(spec2)
            )
        ),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3, tolerance = 10**-9
    ) |>
        print()
}

#rev_set_transform
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_transform()

    spec3 <- eval(
        expr = parse(
            text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_transform(spec2)
            )
        ),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |>
        print()
}

#rev_set_easter
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_easter()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_easter(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

#rev_set_basic
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_basic()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_basic(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

#rev_set_estimate
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_estimate()

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
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_automodel()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_automodel(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

# rev_set_arima
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_arima()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_arima(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

# rev_set_benchmarking
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_benchmarking()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_benchmarking(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

# rev_set_outlier
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_outlier()

    spec3 <- eval(
        expr = parse(text = paste0(
            "rjd3x13::x13_spec(\"RSA3\") |>\n",
            rev_set_outlier(spec2)
        )),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |> print()
}

# rev_set_tradingdays
for (k in 1:100) {
    spec2 <- rjd3x13::x13_spec("RSA3") |>
        random_set_tradingdays()

    spec3 <- eval(
        expr = parse(
            text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_tradingdays(spec2)
            )
        ),
        envir = .GlobalEnv
    )
    waldo::compare(
        spec2,
        spec3
    ) |>
        print()
}
