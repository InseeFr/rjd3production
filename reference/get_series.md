# Extract all series from a SA-Item

Extracts all available time series (pre-adjustment, decomposition, and
final) from a seasonal adjustment item (`jsai`) inside a JDemetra+
workspace.

## Usage

``` r
get_series(x, ...)

# S3 method for class 'JD3_TRAMOSEATS_RSLTS'
get_series(x, name, ...)

# S3 method for class 'JD3_X13_RSLTS'
get_series(x, name, ...)

# S3 method for class 'jobjRef'
get_series(x, ...)
```

## Arguments

- x:

  The object to extract the series

- ...:

  Additional argument

- name:

  Name of the SA object

## Value

A `data.frame` with columns:

- `SAI`: name of the SAI,

- `series`: the type of series (e.g. `"y"`, `"sa"`, `"trend"`),

- `date`: observation dates,

- `value`: numeric values of the series.

## Details

`x` can be a Java SAI object, typically obtained via
[`rjd3workspace::jsap_sai()`](https://rjdverse.github.io/rjd3workspace/reference/jws_sap.html)
after opening and computing a workspace with
[`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
and
[`rjd3workspace::jws_compute()`](https://rjdverse.github.io/rjd3workspace/reference/jws_compute.html).

## Examples

``` r
library("rjd3toolkit")
library("rjd3workspace")

# \donttest{
# Demo workspace
jws <- create_ws_from_data(ABS)
jws_compute(jws)
jsap <- jws_sap(jws, 1L)
jsai <- jsap_sai(jsap, 1L)

df <- get_series(jsai)
head(df)
#>            SAI series       date value
#> 1 X0.2.09.10.M     a1 1982-04-01 460.1
#> 2 X0.2.09.10.M     a1 1982-05-01 502.6
#> 3 X0.2.09.10.M     a1 1982-06-01 443.8
#> 4 X0.2.09.10.M     a1 1982-07-01 459.1
#> 5 X0.2.09.10.M     a1 1982-08-01 438.4
#> 6 X0.2.09.10.M     a1 1982-09-01 465.1
# }
```
