# Assign calendar (TD) regressors to a JDemetra+ workspace

This function updates a JDemetra+ workspace (`.xml`) by assigning
user-defined trading day regressors (TD) to each series (SA-Item), based
on an external correspondence table, which can be created with
[`retrieve_td()`](https://inseefr.github.io/rjd3production/reference/td_tools.md).

This function modifies the `domainSpec` of each series by setting
`tradingdays` to `"UserDefined"` with the appropriate regressors (`REG1`
… `REG6`, optionally with `LY` for leap year).

## Usage

``` r
assign_td(td, jws)
```

## Arguments

- td:

  \[[data.frame](https://rdrr.io/r/base/data.frame.html)\] A data.frame
  with at least two columns:

  - `series`: name of the series in the workspace.

  - `regs`: standard INSEE TD set (`REG1`, `REG2`, …, `REG6`, with or
    without `_LY`) (created by
    [retrieve_td](https://inseefr.github.io/rjd3production/reference/td_tools.md)
    or
    [import_td](https://inseefr.github.io/rjd3production/reference/td_tools.md)).

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

## Value

The object `jws` updated with new td regressors.

## Details

This function only modifies the first SA-Processing.

## Examples

``` r
if (FALSE) { # \dontrun{
# Load a workspace and apply INSEE TD sets
td_table <- retrieve_td("workspace.xml")
assign_td(td = td_table, ws_path = "workspace.xml")
} # }
```
