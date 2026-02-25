# Diagnostics Extraction on Calendar Correction with different sets of regressors

These functions allow to extract diagnostics from X13-Arima models with
different sets of calendar regressors in order to evaluate different
specifications and select the most appropriate calendar regressors set
(with or without leap-year effect) to correct a given series.

## Usage

``` r
get_LY_info(smod, verbose = TRUE)

one_diagnostic(series, spec, context)

all_diagnostics(series, specs_set, context)

verif_LY(jeu, diags)

select_reg_one_series(series, name = "", specs_set = NULL, context = NULL, ...)
```

## Arguments

- smod:

  [list](https://rdrr.io/r/base/list.html) Result of
  [`summary()`](https://rdrr.io/r/base/summary.html) applied to an X13
  model.

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

- specs_set:

  \[[list](https://rdrr.io/r/base/list.html) or NULL\] List of X13
  specifications. If `NULL`, generated via
  [`create_specs_set()`](https://tanguybarthelemy.github.io/rjd3production/reference/create_specs_set.md).

- jeu:

  [character](https://rdrr.io/r/base/character.html) Name of the tested
  regression set.

- diags:

  [data.frame](https://rdrr.io/r/base/data.frame.html) Diagnostics table
  produced by `all_diagnostics()`.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the series
  (for messages).

- ...:

  Additional arguments passed to
  [`create_specs_set()`](https://tanguybarthelemy.github.io/rjd3production/reference/create_specs_set.md)
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
      [`create_specs_set()`](https://tanguybarthelemy.github.io/rjd3production/reference/create_specs_set.md).

## Value

- `get_LY_info()` : A data.frame with `LY_coeff` and `LY_p_value`.

- `one_diagnostic()` : A data.frame with diagnostics for one
  specification.

- `all_diagnostics()` : A data.frame with diagnostics for all
  specifications.

- `verif_LY()` : Name of the chosen regression set (possibly without
  LY).

- `select_reg_one_series()` : Name of the selected regression set.

## Details

- `get_LY_info()` extracts coefficient and p-value of the leap-year (LY)
  effect.

- `one_diagnostic()` applies one X13 specification to a series and
  computes diagnostics.

- `all_diagnostics()` evaluates all specifications in a set and
  summarizes diagnostics.

- `verif_LY()` checks whether the leap-year effect should be kept or
  removed.

- `select_reg_one_series()` selects the best calendar regressors set for
  a single series.

## Examples

``` r
# Create a modelling context
my_context <- create_insee_context(s = AirPassengers)

# Generate specification sets
my_set <- create_specs_set(context = my_context)

# Extract LY info
mod <- rjd3x13::x13(AirPassengers, spec = "RSA3")
rjd3production:::get_LY_info(summary(mod))
#>   LY_coeff LY_p_value
#> 1       NA         NA

# Compute diagnostics for one spec
spec <- my_set[[8L]]
rjd3production:::one_diagnostic(series = AirPassengers, spec, context = my_context)
#>   note     aicc           mode   LY_coeff  LY_p_value
#> 1    0 965.5798 Multiplicative 0.04282008 0.004105741

# Compute diagnostics for all specs
rjd3production:::all_diagnostics(series = AirPassengers, specs_set = my_set, context = my_context)
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
#>            regs note     aicc           mode     LY_coeff   LY_p_value
#> No_TD     No_TD    3 987.3845 Multiplicative           NA           NA
#> REG1       REG1    0 971.5899 Multiplicative -0.002719545 1.511018e-05
#> REG2       REG2    0 973.7502 Multiplicative           NA           NA
#> REG3       REG3    0 975.7970 Multiplicative           NA           NA
#> REG5       REG5    0 951.3999 Multiplicative           NA           NA
#> REG6       REG6    0 980.0282 Multiplicative           NA           NA
#> LY           LY    3 984.0518 Multiplicative  0.039174106 1.941394e-02
#> REG1_LY REG1_LY    0 965.5798 Multiplicative  0.042820081 4.105741e-03
#> REG2_LY REG2_LY    0 952.8547 Multiplicative  0.045206262 6.698235e-04
#> REG3_LY REG3_LY    0 969.7974 Multiplicative  0.042993814 4.285800e-03
#> REG5_LY REG5_LY    0 971.7842 Multiplicative  0.044359491 3.809563e-03
#> REG6_LY REG6_LY    0 974.0675 Multiplicative  0.043817320 4.819346e-03

# Check whether LY should be removed
diags <- rjd3production:::all_diagnostics(
    series = AirPassengers,
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
rjd3production:::select_reg_one_series(series = AirPassengers, context = my_context)
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
#> [1] "REG5"
```
