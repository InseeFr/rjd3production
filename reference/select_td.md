# Select Calendar Regressors for One or Multiple Series

Applies the X13 regression selection procedure to one or more time
series. If multiple series are provided as columns of a matrix or
data.frame, each series is processed separately. The function returns
the selected set of regressors for each series.

## Usage

``` r
select_td(series, context = NULL, ..., verbose = TRUE)
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

- verbose:

  Boolean. Print additional informations. Default is `TRUE`.

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
select_td(ABS)
#> 
#> Série X0.2.09.10.M en cours... 1/22 
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
#> Série X0.2.08.10.M en cours... 2/22 
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
#> Série X0.2.07.10.M en cours... 3/22 
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
#> Série X0.2.06.10.M en cours... 4/22 
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
#> Série X0.2.05.10.M en cours... 5/22 
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
#> Série X0.2.04.10.M en cours... 6/22 
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
#> Série X0.2.03.10.M en cours... 7/22 
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
#> Série X0.2.02.10.M en cours... 8/22 
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
#> Série X0.2.01.10.M en cours... 9/22 
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
#> Série X0.2.15.10.M en cours... 10/22 
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
#> Série X0.2.46.10.M en cours... 11/22 
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
#> Série X0.2.14.10.M en cours... 12/22 
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
#> Série X0.2.45.10.M en cours... 13/22 
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
#> Série X0.2.13.10.M en cours... 14/22 
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
#> Série X0.2.44.10.M en cours... 15/22 
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
#> Série X0.2.12.10.M en cours... 16/22 
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
#> Série X0.2.43.10.M en cours... 17/22 
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
#> Série X0.2.11.10.M en cours... 18/22 
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
#> Série X0.2.42.10.M en cours... 19/22 
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
#> Série X0.2.10.10.M en cours... 20/22 
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
#> Série X0.2.41.10.M en cours... 21/22 
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
#> Série X0.2.20.10.M en cours... 22/22 
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
#>          series    regs
#> 1  X0.2.09.10.M    REG6
#> 2  X0.2.08.10.M    REG6
#> 3  X0.2.07.10.M    REG6
#> 4  X0.2.06.10.M    REG3
#> 5  X0.2.05.10.M    REG3
#> 6  X0.2.04.10.M    REG3
#> 7  X0.2.03.10.M    REG5
#> 8  X0.2.02.10.M    REG6
#> 9  X0.2.01.10.M    REG6
#> 10 X0.2.15.10.M    REG6
#> 11 X0.2.46.10.M    REG6
#> 12 X0.2.14.10.M    REG6
#> 13 X0.2.45.10.M    REG6
#> 14 X0.2.13.10.M    REG6
#> 15 X0.2.44.10.M    REG6
#> 16 X0.2.12.10.M    REG6
#> 17 X0.2.43.10.M    REG6
#> 18 X0.2.11.10.M REG3_LY
#> 19 X0.2.42.10.M    REG6
#> 20 X0.2.10.10.M    REG3
#> 21 X0.2.41.10.M    REG6
#> 22 X0.2.20.10.M    REG6

# Restrict regressors sets
my_context <- create_insee_context(s = ABS)
my_context$variables <- my_context$variables[c("REG1", "REG1_LY", "REG6", "REG6_LY")]
select_td(ABS, context = my_context)
#> 
#> Série X0.2.09.10.M en cours... 1/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.08.10.M en cours... 2/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.07.10.M en cours... 3/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.06.10.M en cours... 4/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.05.10.M en cours... 5/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.04.10.M en cours... 6/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.03.10.M en cours... 7/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.02.10.M en cours... 8/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.01.10.M en cours... 9/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.15.10.M en cours... 10/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.46.10.M en cours... 11/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.14.10.M en cours... 12/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.45.10.M en cours... 13/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.13.10.M en cours... 14/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.44.10.M en cours... 15/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.12.10.M en cours... 16/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.43.10.M en cours... 17/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.11.10.M en cours... 18/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.42.10.M en cours... 19/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.10.10.M en cours... 20/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.41.10.M en cours... 21/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.20.10.M en cours... 22/22 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#>          series regs
#> 1  X0.2.09.10.M REG6
#> 2  X0.2.08.10.M REG6
#> 3  X0.2.07.10.M REG6
#> 4  X0.2.06.10.M REG6
#> 5  X0.2.05.10.M REG6
#> 6  X0.2.04.10.M REG6
#> 7  X0.2.03.10.M REG6
#> 8  X0.2.02.10.M REG6
#> 9  X0.2.01.10.M REG6
#> 10 X0.2.15.10.M REG6
#> 11 X0.2.46.10.M REG6
#> 12 X0.2.14.10.M REG6
#> 13 X0.2.45.10.M REG6
#> 14 X0.2.13.10.M REG6
#> 15 X0.2.44.10.M REG6
#> 16 X0.2.12.10.M REG6
#> 17 X0.2.43.10.M REG6
#> 18 X0.2.11.10.M REG6
#> 19 X0.2.42.10.M REG6
#> 20 X0.2.10.10.M REG6
#> 21 X0.2.41.10.M REG6
#> 22 X0.2.20.10.M REG6
# }
```
