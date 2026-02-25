# Select Calendar Regressors for One or Multiple Series

Applies the X13 regression selection procedure to one or more time
series. If multiple series are provided as columns of a matrix or
data.frame, each series is processed separately. The function returns
the selected set of regressors for each series.

## Usage

``` r
select_regs(series, context = NULL, ...)
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

A data.frame with two columns:

- series:

  Name of the series (column name if `series` is multivariate).

- reg_selected:

  Name of the selected regressor set.

## Examples

``` r
# Single series
select_regs(AirPassengers)
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

# Multiple series
select_regs(Seatbelts[, -8])
#> 
#> Série DriversKilled en cours... 1/7 
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
#> Warning: Aucun jeu de regresseur n'est significatif. (Série DriversKilled)
#> 
#> Série drivers en cours... 2/7 
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
#> Warning: Aucun jeu de regresseur n'est significatif. (Série drivers)
#> 
#> Série front en cours... 3/7 
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
#> Série rear en cours... 4/7 
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
#> Série kms en cours... 5/7 
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
#> Série PetrolPrice en cours... 6/7 
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
#> Série VanKilled en cours... 7/7 
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
#> Warning: Aucun jeu de regresseur n'est significatif. (Série VanKilled)
#>      series          reg_selected
#> [1,] "DriversKilled" "No_TD"     
#> [2,] "drivers"       "REG6"      
#> [3,] "front"         "REG5"      
#> [4,] "rear"          "REG1"      
#> [5,] "kms"           "REG1"      
#> [6,] "PetrolPrice"   "No_TD"     
#> [7,] "VanKilled"     "No_TD"     

# Restrict regressors sets
my_context <- create_insee_context()
my_context$variables <- my_context$variables[c("REG1", "REG1_LY", "REG6", "REG6_LY")]
select_regs(Seatbelts[, -8], context = my_context)
#> 
#> Série DriversKilled en cours... 1/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> Warning: Aucun jeu de regresseur n'est significatif. (Série DriversKilled)
#> 
#> Série drivers en cours... 2/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> Warning: Aucun jeu de regresseur n'est significatif. (Série drivers)
#> 
#> Série front en cours... 3/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série rear en cours... 4/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série kms en cours... 5/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série PetrolPrice en cours... 6/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> Warning: Aucun jeu de regresseur n'est significatif. (Série PetrolPrice)
#> 
#> Série VanKilled en cours... 7/7 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec REG6_LY ...Done !
#> Warning: Aucun jeu de regresseur n'est significatif. (Série VanKilled)
#>      series          reg_selected
#> [1,] "DriversKilled" "No_TD"     
#> [2,] "drivers"       "No_TD"     
#> [3,] "front"         "No_TD"     
#> [4,] "rear"          "No_TD"     
#> [5,] "kms"           "No_TD"     
#> [6,] "PetrolPrice"   "No_TD"     
#> [7,] "VanKilled"     "No_TD"     
```
