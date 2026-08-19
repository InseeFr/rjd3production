# Setup a production chain with JDemetra+

    #> Installing package into '/home/runner/work/_temp/Library'
    #> (as 'lib' is unspecified)

``` r

library("rjd3production")
```

The {rjd3production} package is useful for setting up a production
pipeline for seasonally adjusted time series.

Before creating our production pipeline, we need to set up our working
environment – our project. The
[`init_env()`](https://inseefr.github.io/rjd3production/reference/init_env.md)
function creates the following structure:

- a `data/` folder: our raw data
- a `Workspaces/` folder: our workspaces
- an `output/` folder: the output time series, tables and graphs
- a `specs/` folder: workspace-specific specifications (calendar
  regressors, outliers, etc.)
- a `BQ/` folder: quality reports and decision files
- a DESCRIPTION file to manage our project’s dependencies
- a `.lintr` file for static code analysis (formatting best practices)
- a README.md file to explain our project
- a Git project structure

``` r

path_project <- tempfile(pattern = "my_sa_project")
init_env(path = path_project)
```

In this tutorial, we will create a production pipeline using the ABS
dataset from the {rjd3toolkit} package. The dataset is also available as
the file `ABS.csv` at
/home/runner/work/\_temp/Library/rjd3providers/extdata/ABS.csv in the
{rjd3providers} package.

``` r

library("rjd3toolkit")
path_ABS <- system.file("extdata", "ABS.csv", package = "rjd3providers")
my_data <- ABS[, seq_len(3L)]
colnames(my_data) <- substr(colnames(my_data), start = 2L, stop = 12L)
```

## Selection of calendar regressors

If our time series are sensitive to calendar effects, we can correct for
these effects using calendar regressors.

To do this, refer to the `td-selection` vignette for guidance on how to
handle these effects and how to generate the `td` table containing our
selected custom calendar regressors.

``` r

td <- select_td(my_data)
#> 
#> Série 0.2.09.10.M en cours... 1/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série 0.2.08.10.M en cours... 2/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série 0.2.07.10.M en cours... 3/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
```

## Creating a workspace

We will use the {rjd3workspace} package for functions relating to the
creation and manipulation of workspaces.

``` r

library("rjd3workspace")
```

To create a new workspace, you can either create it manually from
scratch or from a dataset. If you are using external variables, calendar
regressors or a custom calendar, don’t forget to place all of these
within a modelling context.

At INSEE, we use the
[`create_insee_context()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
function to create our contexts:

``` r

my_context <- create_insee_context(s = my_data[, 1L])
```

We will use the {rjd3x13} package to create the X13 specs.

``` r

library("rjd3x13")
```

- Create a workspace from scratch

``` r

jws <- jws_new(modelling_context = my_context)
jsap <- jws_sap_new(jws, "Nouveau SAP")
add_sa_item(jsap = jsap, name = "Première série", x = my_data[, 1L], spec = x13_spec())
add_sa_item(jsap = jsap, name = "Seconde série", x = my_data[, 2L], spec = x13_spec())
#... avec autant de commande que de séries
```

- Create a workspace from a dataset

``` r

jws <- create_ws_from_data(my_data)
set_context(jws, create_insee_context(s = my_data))
```

If we have any, we need to assign calendar regressors to each series:

``` r

jws_compute(jws)
assign_td(td = td, jws = jws)
#> Série 0.2.09.10.M, 1/3
#> Série 0.2.08.10.M, 2/3
#> Série 0.2.07.10.M, 3/3
```

Don’t forget to update the metadata for our workspace with the path to
our raw data:

``` r

add_raw_data_path(jws, path_ABS, delimiter = "COMMA")
```

At last, we can save our workspace!

``` r

path_ws <- file.path(path_project, "Workspaces", "workspace_travail", "my_ws.xml")
save_workspace(jws, path_ws, replace = TRUE)
```

## Call from the cruncher

In an R production pipeline, the cruncher plays a vital role as it
enables:

1.  Updating the raw data from the data file
2.  Updating the seasonal adjustment model (according to a refresh
    policy)
3.  Production of outputs
