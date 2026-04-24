# Run the Shiny comparison app

Launches an interactive Shiny application to explore and compare
seasonal adjustment results stored in a `data.frame` returned by
[`compare()`](https://inseefr.github.io/rjd3production/reference/compare.md).

## Usage

``` r
run_app(data, ...)
```

## Arguments

- data:

  A `data.frame` returned by
  [`compare()`](https://inseefr.github.io/rjd3production/reference/compare.md),
  containing the columns `ws`, `SAI`, `series`, `date`, and `value`.

- ...:

  Additional arguments passed to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).

## Value

Runs a Shiny app in the R session (no return value).

## Examples

``` r
library("rjd3toolkit")
library("rjd3x13")
library("rjd3workspace")

# \donttest{
# Two demo workspaces (RSA3 and RSA5)
jws_rsa3 <- create_ws_from_data(ABS, x13_spec("rsa3"))
jws_rsa5 <- create_ws_from_data(ABS, x13_spec("rsa5"))

path_rsa3 <- tempfile(pattern = "ws-rsa3", fileext = ".xml")
path_rsa5 <- tempfile(pattern = "ws-rsa5", fileext = ".xml")

save_workspace(jws_rsa3, file = path_rsa3)
save_workspace(jws_rsa5, file = path_rsa5)

# Compare the two workspace
df <- compare(path_rsa3, path_rsa5, series_names = "X0.2.09.10.M")
head(df)
#>                    ws          SAI series       date value
#> 1 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-04-01 460.1
#> 2 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-05-01 502.6
#> 3 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-06-01 443.8
#> 4 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-07-01 459.1
#> 5 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-08-01 438.4
#> 6 ws-rsa3247678ca09a1 X0.2.09.10.M     a1 1982-09-01 465.1

# Launch the shiny app
if (interactive()) {
    run_app(df)
}
# }
```
