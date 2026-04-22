# Make a workspace crunchable

Complete and replace the ts metadata of a WS to make it crunchable

## Usage

``` r
make_ws_crunchable(jws, verbose = TRUE)
```

## Arguments

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

- verbose:

  Boolean. Print additional informations. Default is `TRUE`.

## Value

A java workspace (as jws) but with new ts metadata

## Details

New metadata are added from temporary files created on the heap. Thus,
this operation is not intended to make the workspace crunchable in a
stable way over time, but rather for a short period of time for testing
purposes, in particular when we are sent a workspace without the raw
data.

## Examples

``` r
library("rjd3workspace")
library("rjd3x13")
library("rjd3toolkit")

jws <- jws_new()
jsap <- jws_sap_new(jws, "sap1")
add_sa_item(
    jsap = jsap,
    name = "series_3",
    x = ABS[, 1],
    spec = x13_spec("RSA3")
)
jws <- make_ws_crunchable(jws)
#> SAP n°1
#> SAI n°1
```
