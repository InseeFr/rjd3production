# Retrieve a SA-Item by its name

Searches a workspace for a seasonal adjustment item (SAI) whose name
matches the user-supplied string and returns the corresponding object.

## Usage

``` r
get_jsai_by_name(jws, series_name)
```

## Arguments

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

- series_name:

  [character](https://rdrr.io/r/base/character.html) Name of the SAI to
  retrieve.

## Value

A Java Seasonal Adjustment Item object (`jsai`).

## Examples

``` r
if (FALSE) { # \dontrun{
path <- file.path(tempdir(), "workspace_RSA3.xml")
jws <- jws_open(path)
jws_compute(jws)

jsai <- get_jsai_by_name(jws, "series_1")
df <- get_series(jsai)
head(df)
} # }
```
