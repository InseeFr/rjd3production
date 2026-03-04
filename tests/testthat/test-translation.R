
set.seed(2026L)

test_that("rev_set_x11 works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_x11()

        spec_test <- eval(
            expr = parse(
                text = paste0(
                    "rjd3x13::x13_spec(\"RSA3\") |>\n",
                    rev_set_x11(spec_ref)
                )
            ),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_add_ramp works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_add_ramp()

        spec_test <- eval(
            expr = parse(
                text = paste0(
                    "rjd3x13::x13_spec(\"RSA3\") |>\n",
                    rev_add_ramp(spec_ref)
                )
            ),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_transform works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_transform()

        spec_test <- eval(
            expr = parse(
                text = paste0(
                    "rjd3x13::x13_spec(\"RSA3\") |>\n",
                    rev_set_transform(spec_ref)
                )
            ),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_easter works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_easter()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_easter(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_basic works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_basic()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_basic(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_estimate works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_estimate()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_estimate(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_add_usrdefvar works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_add_usrdefvar()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_add_usrdefvar(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_automodel works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_automodel()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_automodel(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_arima works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_arima()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_arima(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_benchmarking works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_benchmarking()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_benchmarking(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_outlier works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_outlier()

        spec_test <- eval(
            expr = parse(text = paste0(
                "rjd3x13::x13_spec(\"RSA3\") |>\n",
                rev_set_outlier(spec_ref)
            )),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_set_tradingdays works", {
    for (k in 1:100) {
        spec_ref <- rjd3x13::x13_spec("RSA3") |>
            random_set_tradingdays()

        spec_test <- eval(
            expr = parse(
                text = paste0(
                    "rjd3x13::x13_spec(\"RSA3\") |>\n",
                    rev_set_tradingdays(spec_ref)
                )
            ),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})

test_that("rev_spec works", {
    for (k in 1:100) {
        spec_ref <- random_spec()
        spec_test <- eval(
            expr = parse(
                text = rev_spec(spec_ref)
            ),
            envir = .GlobalEnv
        )
        testthat::expect_identical(spec_ref, spec_test)
    }
})
