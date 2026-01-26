#' @title INSEE Regressors and Modelling Context
#'
#' @description
#' These functions allow constructing the standard regressors and context
#' used by INSEE for seasonal adjustment:
#'
#' - [create_french_calendar()] creates the French national calendar.
#' - [create_insee_regressors()] generates working day regressors and leap-year effect (LY).
#' - [create_insee_regressors_sets()] organizes these regressors into standard sets (REG1, REG2, …, REG6, with or without LY).
#' - [create_insee_context()] combines the regressors and calendar into a `modelling_context` object
#'   that can be used directly with `rjd3toolkit`.
#'
#' @param start [\link[base]{integer} vector] Start period in the format `c(year, month)` (default `c(1990, 1)`).
#' @param frequency [integer] Series frequency (default `12L`).
#' @param length [integer] Series length (default `492L`).
#' @param s [\link[base]{numeric} or NULL] Optional argument for adjustment (passed to `rjd3toolkit`).
#'
#' @return
#' - `create_french_calendar()` returns a `national_calendar` object.
#' - `create_insee_regressors()` returns a matrix of regressors (working days + LY).
#' - `create_insee_regressors_sets()` returns a list of regressor sets (`REG1`, `REG2`, …, `REG6`, with or without LY).
#' - `create_insee_context()` returns a `modelling_context` object.
#'
#' @examples
#' # 1. Create the French calendar
#' cal <- create_french_calendar()
#' cal
#'
#' # 2. Generate regressors
#' regs <- create_insee_regressors(start = c(2000, 1), frequency = 12, length = 240)
#' head(regs)
#'
#' # 3. Organize into standard sets
#' sets <- create_insee_regressors_sets(start = c(2000, 1), frequency = 12, length = 240)
#' names(sets)
#'
#' # 4. Build a complete context for rjd3toolkit
#' context <- create_insee_context(start = c(2000, 1), frequency = 12, length = 240)
#' context
#'
#' @name insee_modelling
NULL


#' @rdname insee_modelling
#' @importFrom rjd3toolkit national_calendar fixed_day special_day
#' @export
create_french_calendar <- function() {
    cal <- rjd3toolkit::national_calendar(
        days = list(
            Bastille_day = rjd3toolkit::fixed_day(7, 14), # Bastille Day
            Victory_day = rjd3toolkit::fixed_day(
                5,
                8,
                validity = list(start = "1982-05-08")
            ), # Victoire 2nd guerre mondiale
            NEWYEAR = rjd3toolkit::special_day("NEWYEAR"), # Nouvelle année
            CHRISTMAS = rjd3toolkit::special_day("CHRISTMAS"), # Noël
            MAYDAY = rjd3toolkit::special_day("MAYDAY"), # 1er mai
            EASTERMONDAY = rjd3toolkit::special_day("EASTERMONDAY"), # Lundi de Pâques
            ASCENSION = rjd3toolkit::special_day("ASCENSION"), # attention +39 et pas 40 jeudi ascension
            WHITMONDAY = rjd3toolkit::special_day("WHITMONDAY"), # Lundi de Pentecôte (1/2 en 2005 a verif)
            ASSUMPTION = rjd3toolkit::special_day("ASSUMPTION"), # Assomption
            ALLSAINTSDAY = rjd3toolkit::special_day("ALLSAINTSDAY"), # Toussaint
            ARMISTICE = rjd3toolkit::special_day("ARMISTICE")
        )
    )

    return(cal)
}

#' @importFrom rjd3toolkit calendar_td lp_variable
#' @rdname insee_modelling
#' @export
create_insee_regressors <- function(
    start = c(1990L, 1L),
    frequency = 12L,
    length = 492L,
    s = NULL,
    cal = NULL
) {
    if (is.null(cal)) {
        cal <- create_french_calendar()
    }

    groups <- list(
        REG1 = c(1L, 1L, 1L, 1L, 1L, 0L, 0L),
        REG2 = c(1L, 1L, 1L, 1L, 1L, 2L, 0L),
        REG3 = c(1L, 2L, 2L, 2L, 2L, 3L, 0L),
        REG5 = c(1L, 2L, 3L, 4L, 5L, 0L, 0L),
        REG6 = c(1L, 2L, 3L, 4L, 5L, 6L, 0L)
    )

    regs_cjo <- lapply(
        X = groups,
        FUN = rjd3toolkit::calendar_td,
        calendar = cal,
        frequency = frequency,
        start = start,
        length = length,
        s = s
    ) |>
        do.call(what = cbind)
    cols <- colnames(regs_cjo) |>
        gsub(pattern = ".", replacement = "_", fixed = TRUE)
    regs_cjo <- cbind(
        LY = rjd3toolkit::lp_variable(
            frequency = frequency,
            start = start,
            length = length,
            s = s,
            type = "LeapYear"
        ),
        regs_cjo
    )
    colnames(regs_cjo)[-1] <- cols

    return(regs_cjo)
}

#' @rdname insee_modelling
#' @export
create_insee_regressors_sets <- function(
    start = c(1990L, 1L),
    frequency = 12L,
    length = 492L,
    s = NULL,
    cal = NULL
) {
    regs_cjo <- create_insee_regressors(
        frequency = frequency,
        start = start,
        length = length,
        s = s,
        cal = cal
    )

    n <- colnames(regs_cjo)

    REG1 <- regs_cjo[, startsWith(n, prefix = "REG1"), drop = FALSE]
    attr(REG1, "class") <- c("mts", "ts", "matrix", "array")

    LY <- regs_cjo[, startsWith(n, prefix = "LY"), drop = FALSE]
    attr(LY, "class") <- c("mts", "ts", "matrix", "array")

    sets <- list(
        REG1 = REG1,
        REG2 = regs_cjo[, startsWith(n, prefix = "REG2")],
        REG3 = regs_cjo[, startsWith(n, prefix = "REG3")],
        REG5 = regs_cjo[, startsWith(n, prefix = "REG5")],
        REG6 = regs_cjo[, startsWith(n, prefix = "REG6")],
        LY = LY,
        REG1_LY = regs_cjo[,
            startsWith(n, prefix = "REG1") |
                startsWith(n, prefix = "LY")
        ],
        REG2_LY = regs_cjo[,
            startsWith(n, prefix = "REG2") |
                startsWith(n, prefix = "LY")
        ],
        REG3_LY = regs_cjo[,
            startsWith(n, prefix = "REG3") |
                startsWith(n, prefix = "LY")
        ],
        REG5_LY = regs_cjo[,
            startsWith(n, prefix = "REG5") |
                startsWith(n, prefix = "LY")
        ],
        REG6_LY = regs_cjo[,
            startsWith(n, prefix = "REG6") |
                startsWith(n, prefix = "LY")
        ]
    )

    return(sets)
}

#' @importFrom rjd3toolkit modelling_context
#' @rdname insee_modelling
#' @export
create_insee_context <- function(
    start = c(1990L, 1L),
    frequency = 12L,
    length = 492L,
    s = NULL
) {
    cal_fr <- create_french_calendar()
    variables_fr <- create_insee_regressors_sets(
        start = start,
        frequency = frequency,
        length = length,
        s = s
    )
    context <- rjd3toolkit::modelling_context(
        variables = variables_fr,
        calendars = list(FR = cal_fr)
    )
    return(context)
}


#' @title Création d'un ensemble de spécifications X13
#'
#' @description
#' Construit un jeu de spécifications X13 à partir d'une date de début,
#' d'un contexte (variables explicatives) et éventuellement d'outliers.
#'
#' @param span_start [character] Date de début de l'estimation (format "YYYY-MM-DD").
#' @param context [list] Contexte de modélisation créé par
#'   [rjd3toolkit::modelling_context()].
#' @param outliers [\link[base]{list} or NULL] Liste optionnelle avec les éléments :
#'   \itemize{
#'     \item `type` : vecteur de types d'outliers (ex. "AO", "LS", "TC")
#'     \item `date` : vecteur de dates correspondantes
#'   }
#'
#' @return Une liste de spécifications X13 nommées (CJO et variantes).
#'
#' @examples
#' my_context <- create_insee_context()
#' create_specs_set(context = my_context)
#'
#' @importFrom rjd3x13 x13_spec
#' @importFrom rjd3toolkit set_estimate add_outlier set_tradingdays
#' @export
create_specs_set <- function(
    spec_0 = NULL,
    context = NULL,
    outliers = NULL,
    span_start = NULL
) {
    if (is.null(context)) {
        context <- create_insee_context()
    }
    var_names <- get_named_variables(context)
    if (is.null(spec_0)) {
        spec_0 <- rjd3x13::x13_spec(name = "RSA3")
    }
    if (!is.null(span_start)) {
        spec_0 <- spec_0 |>
            rjd3toolkit::set_estimate(type = "From", d0 = span_start)
    }
    if (!is.null(outliers)) {
        spec_0 <- spec_0 |>
            rjd3toolkit::add_outlier(
                type = outliers$type,
                date = as.character(outliers$date)
            )
    }
    specs_set <- c(
        list(Pas_CJO = spec_0),
        lapply(
            X = var_names,
            FUN = rjd3toolkit::set_tradingdays,
            x = spec_0,
            option = "UserDefined",
            test = "None",
            calendar.name = NA
        )
    )
    return(specs_set)
}
