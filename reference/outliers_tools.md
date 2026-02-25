# Manage outliers from JDemetra+ workspaces

These functions allow extracting, exporting and importing outliers
detected in a JDemetra+ workspace:

- `retrieve_outliers()` extracts outliers from a `.xml` workspace.

- `export_outliers()` saves extracted outliers into a YAML file.

- `import_outliers()` loads outliers back to a `.xml` workspace from a
  YAML file.

They are useful for archiving and reusing outliers detected during
seasonal adjustment workflows.

## Usage

``` r
export_outliers(x, ws_name, path = NULL, verbose = TRUE)

import_outliers(ws_name, path = NULL, verbose = TRUE)

retrieve_outliers(
  jws,
  domain = TRUE,
  estimation = FALSE,
  point = FALSE,
  verbose = TRUE
)
```

## Arguments

- x:

  [list](https://rdrr.io/r/base/list.html) A list of outliers, as
  returned by `retrieve_outliers()`.

- ws_name:

  \[[character](https://rdrr.io/r/base/character.html)\] The name of the
  workspace, used to build default YAML filenames.

- path:

  \[[character](https://rdrr.io/r/base/character.html)\] Path to a YAML
  file to write to or read from. If missing, defaults to
  `"regression/outliers_<ws_name>.yaml"`.

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

- `retrieve_outliers()` returns a named list where each element
  corresponds to a series in the workspace and contains the names of
  existing (detected or pre-specified) outliers.

- `export_outliers()` invisibly returns the path of the YAML file
  written.

- `import_outliers()` returns a list of outliers read from a YAML file.

## Examples

``` r
library("rjd3workspace")
# Load a Workspace
file <- system.file("workspaces", "workspace_test.xml", package = "rjd3workspace")
jws <- jws_open(file)

my_dir <- tempdir()

outliers <- retrieve_outliers(jws, point = TRUE, domain = FALSE, estimation = FALSE)
#> Série RF0812, 1/5
#> Série RF0893, 2/5
#> Série RF0899, 3/5
#> Série RF1011, 4/5
#> Série RF1012, 5/5
export_outliers(outliers, ws_name = "workspace1", path = my_dir)
#> The outliers will be written at  /tmp/RtmpzM0hG2/outliers_workspace1.yaml 
imported <- import_outliers(ws_name = "workspace1", path = my_dir)
#> The outliers will be read at  /tmp/RtmpzM0hG2/outliers_workspace1.yaml 
```
