# Make a workspace crunchable

Complete and replace the ts metadata of a WS to make it crunchable

## Usage

``` r
make_ws_crunchable(jws, verbose = TRUE)
```

## Arguments

- jws:

  The java representation of the workspace

- verbose:

  Boolean. Print additional informations.

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
jws <- jws_new()
#> Error in jws_new(): could not find function "jws_new"
jsap <- jws_sap_new(jws, "sap1")
#> Error in jws_sap_new(jws, "sap1"): could not find function "jws_sap_new"
add_sa_item(
    jsap = jsap,
    name = "series_3",
    x = AirPassengers,
    spec = rjd3x13::x13_spec("RSA3")
)
#> Error in add_sa_item(jsap = jsap, name = "series_3", x = AirPassengers,     spec = rjd3x13::x13_spec("RSA3")): could not find function "add_sa_item"
jws <- make_ws_crunchable(jws)
#> Error: object 'jws' not found
```
