# Select Calendar Regressors for One or Multiple Series

Applies the X13 regression selection procedure to one or more time
series. If multiple series are provided as columns of a matrix or
data.frame, each series is processed separately. The function returns
the selected set of regressors for each series.

## Usage

``` r
select_td(
  series,
  context = NULL,
  ...,
  thresholds = getOption("rjd3production.thresholds"),
  verbose = TRUE
)
```

## Arguments

- series:

  \[[ts](https://rdrr.io/r/stats/ts.html) or mts or matrix or
  [data.frame](https://rdrr.io/r/base/data.frame.html)\] A univariate
  time series (`ts`) or a multivariate series (columns as separate
  series).

- context:

  [list](https://rdrr.io/r/base/list.html) Modeling context created by
  [`rjd3toolkit::modelling_context()`](https://rjdverse.github.io/rjd3toolkit/reference/modelling_context.html).

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

- thresholds:

  The thresholds used to compare the different model and set a grade to
  an adjustment based on the td residuals p-value and leap year
  significancy.

- verbose:

  Boolean indicating whether to print additional information. Default is
  `TRUE`.

## Value

A data.frame with two columns:

- series:

  Name of the series (column name if `series` is multivariate).

- regs:

  Name of the selected regressor set.

## Examples

``` r
library("rjd3toolkit")

# \donttest{
# Single series
select_td(ABS[, 1])
#> 
#> Série my_series en cours... 1/1 
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
#>      series regs
#> 1 my_series REG6

# Multiple series
select_td(ABS[, 5:7])
#> 
#> Série X0.2.05.10.M en cours... 1/3 
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
#> 
#> Série X0.2.04.10.M en cours... 2/3 
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
#> 
#> Série X0.2.03.10.M en cours... 3/3 
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
#>         series regs
#> 1 X0.2.05.10.M REG3
#> 2 X0.2.04.10.M REG3
#> 3 X0.2.03.10.M REG5

# Restrict regressors sets
my_context <- create_insee_context(s = ABS)
my_context$variables <- my_context$variables[c("REG1", "REG1_LY", "REG6", "REG6_LY")]
select_td(ABS[, 5:7], context = my_context)
#> 
#> Série X0.2.05.10.M en cours... 1/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.04.10.M en cours... 2/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.03.10.M en cours... 3/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#>         series regs
#> 1 X0.2.05.10.M REG6
#> 2 X0.2.04.10.M REG6
#> 3 X0.2.03.10.M REG6
# }
```
