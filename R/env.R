#' @importFrom usethis create_project
init_env <- function(path, open = FALSE) {
    if (dir.exists(path)) {
        stop("The project exist already.")
    }
    dir.create(path, recursive = TRUE)
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

    file.create(file.path(path, ".lintr"))
    file.create(file.path(path, "DESCRIPTION"))
    file.create(file.path(path, ".Renviron"))
    file.create(file.path(path, ".Rprofile"))
    file.create(file.path(path, "README.Rmd"))

    usethis::create_project(rstudio = TRUE, path = path, open = open)
    return(invisible(path))
}
