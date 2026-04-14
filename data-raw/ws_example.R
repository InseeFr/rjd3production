## code to prepare `ws_example` dataset goes here

library("rjd3toolkit")
library("rjd3x13")
library("rjd3workspace")

set.seed(2025L)

context_FR <- create_insee_context()

jws <- jws_new(modelling_context = context_FR)
jsap <- jws_sap_new(jws, name = "ABS")

for (id_series in seq_len(ncol(ABS))) {
    # Outliers - domain
    nb_out <- sample.int(10L, size = 1L)
    out_date <- paste(
        sample(1983L:2017L, size = nb_out, replace = TRUE),
        sample(sprintf("%02d", seq_len(12L)), size = nb_out, replace = TRUE),
        "01",
        sep = "-"
    )
    out_type <- sample(c("AO", "TC", "LS"), size = nb_out, replace = TRUE)

    dspec <- x13_spec("RSA3") |>
        add_outlier(type = out_type, date = out_date)

    td <- sample(
        c(
            "TradingDays",
            "WorkingDays",
            "TD2c",
            "TD3",
            "TD3c",
            "TD4",
            "None",
            "UserDefined",
            "Stock"
        ),
        size = 1L
    )

    if (td == "Stock") {
        dspec <- dspec |>
            set_tradingdays(stocktd = sample.int(31L, size = 1L))
    } else if (td == "UserDefined") {
        set <- sample(names(context_FR$variables), size = 1L)
        dspec <- dspec |>
            set_tradingdays(
                option = "UserDefined",
                uservariable = paste0(
                    set,
                    ".",
                    names(context_FR$variables[[set]])
                ),
                test = "None"
            )
    } else {
        dspec <- dspec |>
            set_tradingdays(
                option = td,
                test = "None"
            )
    }

    add_sa_item(
        jsap,
        name = colnames(ABS)[id_series],
        x = ABS[, id_series],
        spec = dspec
    )

    # Outliers - estimation
    nb_out <- sample.int(10L, size = 1L)
    out_date <- paste(
        sample(1983L:2017L, size = nb_out, replace = TRUE),
        sample(sprintf("%02d", seq_len(12L)), size = nb_out, replace = TRUE),
        "01",
        sep = "-"
    )
    out_type <- sample(c("AO", "TC", "LS"), size = nb_out, replace = TRUE)

    espec <- dspec |>
        add_outlier(type = out_type, date = out_date)
    set_specification(jsap, idx = id_series, spec = espec)
}

save_workspace(jws, file = "inst/workspaces/ws_example.xml")
