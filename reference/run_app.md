# Run the Shiny comparison app

Launches an interactive Shiny application to explore and compare
seasonal adjustment results stored in a `data.frame` returned by
[`compare()`](https://tanguybarthelemy.github.io/rjd3production/reference/compare.md).

## Usage

``` r
run_app(data, ...)
```

## Arguments

- data:

  A `data.frame` returned by
  [`compare()`](https://tanguybarthelemy.github.io/rjd3production/reference/compare.md),
  containing the columns `ws`, `SAI`, `series`, `date`, and `value`.

- ...:

  Additional arguments passed to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).

## Value

Runs a Shiny app in the R session (no return value).

## Examples

``` r
if (FALSE) { # \dontrun{
df <- compare(path1, path2)
run_app(df)
} # }
```
