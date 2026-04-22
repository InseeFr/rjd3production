# Diagnostics Extraction on Calendar Correction with different sets of regressors

These functions allow to extract diagnostics from X13-Arima models with
different sets of calendar regressors in order to evaluate different
specifications and select the most appropriate calendar regressors set
(with or without leap-year effect) to correct a given series.

## Usage

``` r
get_LY_info(mod, verbose = TRUE)
```

## Arguments

- mod:

  [list](https://rdrr.io/r/base/list.html) An X13 model.

- verbose:

  Boolean. Print additional informations. Default is `TRUE`.

- series:

  \[[ts](https://rdrr.io/r/stats/ts.html) or numeric\] Time series to
  analyse.

- spec:

  [list](https://rdrr.io/r/base/list.html) A X13 specification (from
  [`rjd3x13::x13_spec()`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html)).

- context:

  [list](https://rdrr.io/r/base/list.html) Modelling context with
  regressors and calendars (from
  [`rjd3toolkit::modelling_context()`](https://rjdverse.github.io/rjd3toolkit/reference/modelling_context.html)).

- jeu:

  [character](https://rdrr.io/r/base/character.html) Name of the tested
  regression set.

- diags:

  [data.frame](https://rdrr.io/r/base/data.frame.html) Diagnostics table
  produced by `all_diagnostics()`.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the series
  (for messages).

- specs_set:

  \[[list](https://rdrr.io/r/base/list.html) or NULL\] List of X13
  specifications. If `NULL`, generated via
  [`create_specs_set()`](https://inseefr.github.io/rjd3production/reference/create_specs_set.md).

- ...:

  Additional arguments passed to
  [`create_specs_set()`](https://inseefr.github.io/rjd3production/reference/create_specs_set.md)
  controlling the generation of X13 specifications. Possible arguments
  include:

  outliers

  :   Optional list of outliers with elements `type` (vector of types,
      e.g., "AO", "LS", "TC") and `date` (vector of dates).

  span_start

  :   Starting date of the estimation (character, format
      `"YYYY-MM-DD"`).

  ...

  :   Other arguments accepted by
      [`create_specs_set()`](https://inseefr.github.io/rjd3production/reference/create_specs_set.md).

## Value

- `get_LY_info()` : A data.frame with `LY_coeff` and `LY_p_value`.

- `one_diagnostic()` : A data.frame with diagnostics for one
  specification.

- `all_diagnostics()` : A data.frame with diagnostics for all
  specifications.

- `verif_LY()` : Name of the chosen regression set (possibly without
  LY).

- `select_td_one_series()` : Name of the selected regression set.

## Details

- `get_LY_info()` extracts coefficient and p-value of the leap-year (LY)
  effect.

- `one_diagnostic()` applies one X13 specification to a series and
  computes diagnostics.

- `all_diagnostics()` evaluates all specifications in a set and
  summarizes diagnostics.

- `verif_LY()` checks whether the leap-year effect should be kept or
  removed.

- `select_td_one_series()` selects the best calendar regressors set for
  a single series.

## Examples

``` r
library("rjd3toolkit")

# Create a modelling context
my_context <- create_insee_context(s = ABS)

# Generate specification sets
my_set <- create_specs_set(context = my_context)

# Extract LY info
mod <- rjd3x13::x13(ABS[, 1], spec = "RSA3")
rjd3production:::get_LY_info(summary(mod))
#>   LY_coeff LY_p_value
#> 1       NA         NA

# Compute diagnostics for one spec
spec <- my_set[[8L]]
rjd3production:::one_diagnostic(series = ABS[, 1], spec, context = my_context)
#>   note     aicc           mode   LY_coeff  LY_p_value
#> 1    3 4303.737 Multiplicative 0.03630864 0.002140071

# Compute diagnostics for all specs
rjd3production:::all_diagnostics(series = ABS[, 1], specs_set = my_set, context = my_context)
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#>            regs note     aicc           mode   LY_coeff   LY_p_value
#> No_TD     No_TD    3 4309.092 Multiplicative         NA           NA
#> REG1       REG1    3 4311.162 Multiplicative         NA           NA
#> REG2       REG2    3 4307.333 Multiplicative         NA           NA
#> REG3       REG3    3 4254.210 Multiplicative         NA           NA
#> REG5       REG5    3 4252.708 Multiplicative         NA           NA
#> REG6       REG6    3 4232.844 Multiplicative         NA           NA
#> LY           LY    3 4301.656 Multiplicative 0.03633466 0.0021077834
#> REG1_LY REG1_LY    3 4303.737 Multiplicative 0.03630864 0.0021400711
#> REG2_LY REG2_LY    3 4299.263 Multiplicative 0.03721476 0.0015120248
#> REG3_LY REG3_LY    3 4233.953 Multiplicative 0.04192377 0.0001223889
#> REG5_LY REG5_LY    3 4242.804 Multiplicative 0.03814784 0.0005888958
#> REG6_LY REG6_LY    3 4221.123 Multiplicative 0.03900895 0.0002281020

# Check whether LY should be removed
diags <- rjd3production:::all_diagnostics(
    series = ABS[, 1],
    specs_set = my_set,
    context = my_context
)
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
rjd3production:::verif_LY("REG6_LY", diags)
#> [1] "REG6"

# Select regressions for one series
rjd3production:::select_td_one_series(series = ABS[, 1], context = my_context)
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#> [1] "REG6"
```
