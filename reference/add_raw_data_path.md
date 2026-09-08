# Add raw data from a file to a JWS workspace

This function completes the ts metadata (moniker) to make the workspace
refreshable and crunchable.

## Usage

``` r
add_raw_data_path(jws, path, ...)
```

## Arguments

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

- path:

  A character string. Path to the input data file. Must be a `.csv` file
  (support for `.xlsx` is not yet implemented).

- ...:

  Addional arguments passed to
  [`rjd3providers::txt_data()`](https://rjdverse.github.io/rjd3providers/reference/txt_data.html)
  (e.g., delimiter, date format, clean missing argument...).

## Value

The modified `jws` object invisibly.

## Details

Currently, only CSV files are supported. Each column of the input file
is interpreted as a time series and matched against the series names in
the workspace.

The difference with the function
[`make_ws_crunchable`](https://inseefr.github.io/rjd3production/reference/make_ws_crunchable.md)
is that `add_raw_data_path()` will associate the workspace with a non
temporary data path.

## Examples

``` r

library("rjd3workspace")
library("rjd3x13")
#> 
#> Attaching package: ‘rjd3x13’
#> The following object is masked from ‘package:grDevices’:
#> 
#>     x11
library("rjd3toolkit")
#> 
#> Attaching package: ‘rjd3toolkit’
#> The following objects are masked from ‘package:stats’:
#> 
#>     aggregate, mad

my_data <- ABS
colnames(my_data) <- substr(colnames(my_data), start = 2L, stop = 12L)
path_ABS <- system.file("extdata", "ABS.csv", package = "rjd3providers")

# \donttest{
jws <- create_ws_from_data(my_data)
add_raw_data_path(jws, path_ABS, delimiter = "COMMA")
# }
```
