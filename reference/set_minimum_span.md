# Set span minimum to a value

Set span minimum to a value

## Usage

``` r
set_minimum_span(
  spec,
  d0,
  model_span = TRUE,
  series_span = TRUE,
  without_outliers = TRUE
)
```

## Arguments

- spec:

  Specification (object of class `JD3_X13_SPEC` or `JD3_TRAMOSEATS_SPEC`

- d0:

  characters in the format "YYYY-MM-DD" to specify first date of the
  span

- model_span:

  Boolean. Should the estimation (= model) span be modifed?

- series_span:

  Boolean. Should the series (= basic) span be modifed?

- without_outliers:

  Boolean. Should the outliers set before the starting date be removed?
  (Small crutch while waiting for the resolution of jdemetra/jdplus-main
  issue 858.)

## Value

the modify specification (an `JD3_X13_SPEC` or `JD3_TRAMOSEATS_SPEC`
object).

## Details

model_span = estimation_span series_span = basic_span

## Examples

``` r
library("rjd3toolkit")
library("rjd3x13")
library("rjd3workspace")

# \donttest{
# Two demo workspaces (RSA3 and RSA5)
spec <- x13_spec("rsa3")
set_minimum_span(spec, "2012-01-01")
#> Specification
#> 
#> Series
#> Serie span: From 2012-01-01 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: From 2012-01-01 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> No calendar regressor
#> 
#> Easter: No
#> 
#> Pre-specified outliers: 0
#> Ramps: No
#> 
#> Outliers
#> Detection span: All 
#> Outliers type: 
#>  - AO, critical value : 0 (Auto)
#>  - LS, critical value : 0 (Auto)
#>  - TC, critical value : 0 (Auto)
#> TC rate: 0.7 (Auto)
#> Method: ADDONE (Auto)
#> 
#> ARIMA
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>         0         0 
#> 
#> Specification X11
#> Seasonal component: Yes
#> Length of the Henderson filter: 0
#> Seasonal filter: FILTER_MSR
#> Boundaries used for extreme values correction : 
#>   lower_sigma:  1.5 
#>   upper_sigma:  2.5
#> Nb of forecasts: -1
#> Nb of backcasts: 0
#> Calendar sigma: NONE
#> 
#> Benchmarking
#> Is enabled: No
# }
```
