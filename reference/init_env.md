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

if (FALSE) { # \dontrun{
# Create a new project
init_env(path = project_path)
} # }
```
