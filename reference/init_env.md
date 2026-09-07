# Initialize a seasonal adjustment project environment

This function creates a complete project structure for a seasonal
adjustment production workflow. It initializes an R project, sets up
useful directories, configuration files, and development tools.

The generated structure is designed for workflows based on the
'rjdverse'.

## Usage

``` r
init_env(path, open = FALSE)
```

## Arguments

- path:

  A character string. Path where the project will be created.

- open:

  Boolean. Should the project be opened in RStudio after creation?
  Default is `FALSE`.

## Value

The project path invisibly.

## Examples

``` r
project_path <- tempfile(pattern = "my-project")

# \donttest{
# Create a new project
init_env(path = project_path)
#> ✔ Setting active project to "/tmp/RtmpX5VRsV/my-project20067e72d9b0".
#> ✔ Creating R/.
#> ✔ Writing my-project20067e72d9b0.Rproj.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> ✔ Setting active project to "<no active project>".
#> ✔ Setting active project to "/tmp/RtmpX5VRsV/my-project20067e72d9b0".
#> ✔ Writing DESCRIPTION.
#> Type: Project
#> Package: my-project20067e72d9b0
#> Title: What the Package Does (One Line, Title Case)
#> Version: 0.0.0.9000
#> Authors@R (parsed):
#>     * First Last <first.last@example.com> [aut, cre]
#> Description: What the package does (one paragraph).
#> License: `use_mit_license()`, `use_gpl3_license()` or friends to
#>     pick a license
#> Imports:
#>     rjd3production,
#>     rjd3providers,
#>     rjd3qr,
#>     rjd3toolkit,
#>     rjd3workspace,
#>     rjd3x13
#> Suggests:
#>     cyclocomp,
#>     devtools,
#>     lintr,
#>     remotes,
#>     rmarkdown,
#>     usethis
#> Encoding: UTF-8
#> Roxygen: list(markdown = TRUE)
#> RoxygenNote: 7.0.0
#> ✔ Configuring init.defaultBranch as "main".
#> ℹ Remember: this only affects repos you create in the future!
#> ✔ Initialising Git repo.
#> ✔ Adding ".Rhistory", ".RData", ".httr-oauth", ".DS_Store", and ".quarto" to
#>   .gitignore.
# }
```
