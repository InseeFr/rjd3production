# Remove non-significant outliers from a JDemetra+ workspace

This function scans a JDemetra+ workspace (`.xml`) and removes
regression outliers whose p-values are above a given threshold. Both the
estimation specification and the domain specification are updated
accordingly, and the workspace file is saved in place.

Typical use case: after estimation with user pre-specified outliers,
outliers with weak statistical significance (e.g. `p > 0.3`) are dropped
to simplify the regression specification.

## Usage

``` r
remove_non_significative_outliers(
  ws_path,
  threshold = 0.3,
  domain = FALSE,
  estimation = FALSE,
  verbose = TRUE
)
```

## Arguments

- ws_path:

  \[[character](https://rdrr.io/r/base/character.html)\] Path to a
  JDemetra+ workspace file (usually with extension `.xml`).

- threshold:

  \[[numeric](https://rdrr.io/r/base/numeric.html)\] Maximum p-value for
  keeping an outlier. Outliers with `Pr(>|t|) > threshold` are removed.
  Default is `0.3`.

- domain:

  Boolean indicating if the domain specification should be modified.

- estimation:

  Boolean indicating if the estimation specification should be modified.

- verbose:

  Boolean. Print additional informations. Default is `TRUE`.

## Value

The function invisibly returns `NULL`, but it **modifies the workspace
file in place** (saved at the same location as `ws_path`).

## Details

The function:

- iterates over all the series (SA-Items) in the workspace,

- identifies outliers in the `regarima` specification,

- checks their p-values in the pre-processing regression summary,

- removes those with p-values above the threshold from both
  `estimationSpec` and, if present, `domainSpec`,

- saves the workspace file.

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

# Remove non-significant outliers (p > 0.3) from a workspace
remove_non_significative_outliers(path_ws, threshold = 0.3, domain = TRUE)
#> 
#> 🏷 WS  ws247614c3a225 
#> 📌 SAI n° 1 
#> ❌ Suppression de l'outlier : LS (1990-01-01) 
#> L'outlier est dans la domainSpec.
#> 💾 Saving WS file
# }
```
