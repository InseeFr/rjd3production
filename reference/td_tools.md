# Manage trading-day regressors (TD) from JDemetra+ workspaces

These functions allow to extract, export and import the calendar (TD)
regressors used in JDemetra+ workspaces:

- `retrieve_td()` extracts the TD specification from a `.xml` workspace.

- `export_td()` saves extracted TD information into a YAML file.

- `import_td()` loads TD information back from a YAML file.

They are useful for documenting and reusing the regression settings
applied in seasonal adjustment workflows.

## Usage

``` r
export_td(x, ws_name, path = NULL, verbose = TRUE)

import_td(ws_name, path = NULL, verbose = TRUE)

retrieve_td(
  jws,
  domain = TRUE,
  estimation = FALSE,
  point = FALSE,
  verbose = TRUE
)
```

## Arguments

- x:

  \[[list](https://rdrr.io/r/base/list.html) \|
  [data.frame](https://rdrr.io/r/base/data.frame.html)\] An object
  containing the TD information, typically the output of
  `retrieve_td()`.

- ws_name:

  \[[character](https://rdrr.io/r/base/character.html)\] The name of the
  workspace, used to build default YAML file names.

- path:

  \[[character](https://rdrr.io/r/base/character.html)\] Path to a YAML
  file to write to or read from. If missing, defaults to
  `"regression/td_<ws_name>.yaml"`.

- verbose:

  \[[logical](https://rdrr.io/r/base/logical.html)\] Whether to print
  informative messages (default: `TRUE`).

- jws:

  A Java Workspace object, as returned by
  [`rjd3workspace::jws_open()`](https://rjdverse.github.io/rjd3workspace/reference/jws_open.html)
  or
  [`rjd3workspace::jws_new()`](https://rjdverse.github.io/rjd3workspace/reference/jws_new.html).

- domain:

  Boolean indicating if the outliers should be extracted from the domain
  specification.

- estimation:

  Boolean indicating if the outliers should be extracted from the
  estimation specification.

- point:

  Boolean indicating if the outliers should be extracted from the point
  specification.

## Value

- `retrieve_td()` returns a
  [data.frame](https://rdrr.io/r/base/data.frame.html) with columns:

  - `series`: series names,

  - `regs`: TD regressor specification (`REG1`, `REG2`, …, `REG6`, with
    or without `_LY`),

- `export_td()` invisibly returns the path of the YAML file written.

- `import_td()` returns a list or data structure read from YAML.

## Examples

``` r
if (FALSE) { # \dontrun{
ws_file <- "path/to/workspace.xml"

# 1. Retrieve TD specification
td <- retrieve_td(ws_file)

# 2. Export to YAML
export_td(td, ws_name = "workspace1")

# 3. Import back from YAML
imported <- import_td(x = NULL, ws_name = "workspace1")
} # }
```
