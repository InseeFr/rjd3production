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

## Details

model_span = estimation_span series_span = basic_span
