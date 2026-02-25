# Compare series across workspaces

Reads multiple JDemetra+ workspaces and extracts comparable series (by
SAI and series type), returning them in a tidy format. This is
particularly useful to compare results across different specifications
(e.g. RSA3 vs RSA5).

## Usage

``` r
compare(..., series_names)
```

## Arguments

- ...:

  [character](https://rdrr.io/r/base/character.html) Workspace file
  paths.

- series_names:

  [character](https://rdrr.io/r/base/character.html) Vector of SAI names
  to compare.

## Value

A `data.frame` with columns:

- `ws`: workspace name (derived from file basename),

- `SAI`: SAI name,

- `series`: type of series,

- `date`: observation date,

- `value`: numeric value.

## Examples

``` r
if (FALSE) { # \dontrun{
# Two demo workspaces (RSA3 and RSA5)
path1 <- file.path(tempdir(), "workspace_RSA3.xml")
path2 <- file.path(tempdir(), "workspace_RSA5.xml")

df <- compare(path1, path2, series_names = "series_1")
head(df)
} # }
```
