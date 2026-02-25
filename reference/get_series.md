# Extract all series from a SA-Item

Extracts all available time series (pre-adjustment, decomposition, and
final) from a seasonal adjustment item (`jsai`) inside a JDemetra+
workspace.

## Usage

``` r
get_series(jsai)
```

## Arguments

- jsai:

  A Java Seasonal Adjustment Item object, typically obtained via
  [`rjd3workspace::jsap_sai()`](https://rjdverse.github.io/rjd3workspace/reference/jws_sap.html)
  after opening and computing a workspace with
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  and
  [`rjd3workspace::jws_compute()`](https://rjdverse.github.io/rjd3workspace/reference/jws_compute.html).

## Value

A `data.frame` with columns:

- `SAI`: name of the SAI,

- `series`: the type of series (e.g. `"y"`, `"sa"`, `"trend"`),

- `date`: observation dates,

- `value`: numeric values of the series.

## Examples

``` r
if (FALSE) { # \dontrun{
library("rjd3workspace")
path <- file.path(tempdir(), "workspace_RSA3.xml")
jws <- jws_open(path)
jws_compute(jws)
jsap <- jws_sap(jws, 1L)
jsai <- jsap_sai(jsap, 1L)

df <- get_series(jsai)
head(df)
} # }
```
