# Creating a set of X13 specifications

Builds a set of X13 specifications from a start date, a modelling
context (explanatory variables) and outliers (optional).

## Usage

``` r
create_specs_set(
  spec_0 = NULL,
  context = NULL,
  outliers = NULL,
  span_start = NULL
)
```

## Arguments

- spec_0:

  Basic specification

- context:

  [list](https://rdrr.io/r/base/list.html) Modeling context created by
  [`rjd3toolkit::modelling_context()`](https://rjdverse.github.io/rjd3toolkit/reference/modelling_context.html).

- outliers:

  \[[list](https://rdrr.io/r/base/list.html) or NULL\] Optional list
  with elements :

  - `type`: vector of outlier types (e.g. "AO", "LS", "TC")

  - `date`: vector of corresponding dates

- span_start:

  [character](https://rdrr.io/r/base/character.html) Estimation start
  date (format "YYYY-MM-DD").

## Value

A list of named X13 specifications (TD and variants).

## Examples

``` r
my_context <- create_insee_context()
create_specs_set(context = my_context)
#> $No_TD
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
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
#> 
#> $REG1
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG2
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG3
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG5
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG6
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG1_LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG2_LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG3_LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG5_LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
#> $REG6_LY
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: AUTO
#> AIC difference: -2
#> Adjust: NONE
#> 
#> Regression
#> Calendar regressor: user-defined calendar
#> Test: NO
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
#> 
```
