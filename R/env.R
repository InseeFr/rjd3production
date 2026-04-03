#' @importFrom usethis create_project use_readme_rmd use_git use_description
#' @importFrom lintr use_lintr
init_env <- function(path, open = FALSE) {
    if (dir.exists(path)) {
        stop("The project exist already.")
    }

    dir.create(path, recursive = TRUE)
    usethis::create_project(rstudio = TRUE, path = path, open = open)

    file.create(file.path(path, "README.Rmd"))
    writeLines(
        text = paste0(
            "# ",
            basename(path),
            "\n\nChaîne de production de désaisonnalisation. \n\n Structure du projet :",
            paste(
                "un dossier `data/` : nos données brutes",
                "un dossier `Workspaces/` : nos workspaces",
                "un dossier `output/` : les séries, tableaux et graphiques en sortie",
                "un dossier `specs/` : les spécifications propres au workspace (régresseurs de calendrier, outliers...)",
                "un dossier `BQ/` : les bilans qualité et fichiers de décisions",
                "un fichier DESCRIPTION pour gérer les dépendances de notre projet",
                "un fichier `.lintr` pour faire l'analyse statique du code (bonnes pratiques de formattage)",
                "un fichier README.md pour expliquer notre projet",
                sep = "\n- "
            )
        ),
        con = file.path(path, "README.Rmd")
    )

    lintr::use_lintr(path = path)
    writeLines(
        text = "linters: all_linters(
    indentation_linter = lintr::indentation_linter(indent = 4L),
    line_length_linter = lintr::line_length_linter(80L),
    return_linter = NULL,
    library_call_linter = NULL,
    undesirable_function_linter = NULL
    )
encoding: \"UTF-8\"
exclusions: list(\"renv\", \"packrat\")
",
        con = file.path(path, ".lintr")
    )
    usethis::use_description(
        fields = list(
            Imports = "rjd3toolkit, rjd3x13, rjd3providers, rjd3workspace, rjd3production",
            Suggests = "devtools, usethis, remotes, cyclocomp, lintr, rmarkdown"
        )
    )

    dir.create(file.path(path, "data"))
    dir.create(file.path(path, "Workspaces"))
    dir.create(file.path(path, "Workspaces", "workspace_N_1"))
    dir.create(file.path(path, "Workspaces", "workspace_ref"))
    dir.create(file.path(path, "Workspaces", "workspace_auto"))
    dir.create(file.path(path, "Workspaces", "workspace_travail"))
    dir.create(file.path(path, "Workspaces", "workspace_final"))
    dir.create(file.path(path, "output"))
    dir.create(file.path(path, "specs"))
    dir.create(file.path(path, "BQ"))

    file.create(file.path(path, ".Renviron"))
    file.create(file.path(path, ".Rprofile"))

    old_path <- getwd()
    setwd(path)
    usethis::use_git(message = "Nouveau projet de désaisonnalisation !")
    setwd(old_path)

    return(invisible(path))
}
