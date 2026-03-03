# Assign outliers to a JDemetra+ workspace

This function updates a JDemetra+ workspace (`.xml`) by inserting
pre-specified outliers into the `domainSpec` of each series (SA-Item).

## Usage

``` r
assign_outliers(jws, outliers)
```

## Arguments

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

- outliers:

  \[[list](https://rdrr.io/r/base/list.html)\] A named list where each
  element corresponds to a series in the workspace created with
  [retrieve_outliers](https://inseefr.github.io/rjd3production/reference/outliers_tools.md)
  or
  [import_outliers](https://inseefr.github.io/rjd3production/reference/outliers_tools.md).

## Value

The object `jws` updated with new pre-specified outliers.

## Details

This function only modifies the first SA-Processing.

## See also

- [`retrieve_outliers()`](https://inseefr.github.io/rjd3production/reference/outliers_tools.md)
  to extract outliers from an existing workspace.

- [`export_outliers()`](https://inseefr.github.io/rjd3production/reference/outliers_tools.md)
  /
  [`import_outliers()`](https://inseefr.github.io/rjd3production/reference/outliers_tools.md)
  to manage YAML files of outliers.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve outliers from an existing workspace
outs <- retrieve_outliers("workspace.xml")

# Reapply them to another workspace
assign_outliers(outliers = outs, ws_path = "workspace.xml")
} # }
```
