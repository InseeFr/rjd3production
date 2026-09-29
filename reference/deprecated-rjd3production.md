# Deprecated functions

Deprecated functions

## Usage

``` r
remove_non_significative_outliers(
  ws_path,
  threshold = 0.3,
  spec_type = NULL,
  verbose = TRUE
)
```

## Arguments

- ws_path, threshold, spec_type, verbose:

  Parameters.

## Value

The same value as returned by the corresponding non-deprecated function.
The returned object represents an encoded identifier for a spreadsheet
series or collection.

## Examples

``` r

library("rjd3workspace")
library("rjd3x13")
library("rjd3toolkit")

# \donttest{
new_spec <- x13_spec() |>
    add_outlier(type = "LS", date = "1990-01-01")
jws <- create_ws_from_data(x = ABS[, 1, drop = FALSE], spec = new_spec)
path_ws <- tempfile(pattern = "ws", fileext = ".xml")
save_workspace(jws, file = path_ws)

# `remove_non_significative_outliers` is deprecated.
# Use `remove_non_significant_outliers` instead

# Remove non-significant outliers (p > 0.3) from a workspace
remove_non_significant_outliers(
    path_ws,
    threshold = 0.3,
    spec_type = c("Reference", "Estimation")
)
#> 
#> 🏷 WS  ws1f641fdd3603 
#> 📌 SAI n° 1 
#> [1] "X0.2.09.10.M"
#>         series            name type       date
#> 1 X0.2.09.10.M LS (1990-01-01)   LS 1990-01-01
#> 💾 Saving WS file
# }
```
