#' @importFrom yaml write_yaml
#' @rdname outliers_tools
#' @export
export_outliers <- function(x, ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("outliers_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("outliers_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The outliers will be written at ", path, "\n")
    }
    yaml::write_yaml(
        x = x,
        file = path
    )
    return(invisible(path))
}

#' @importFrom yaml read_yaml
#' @rdname outliers_tools
#' @export
import_outliers <- function(ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("outliers_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("outliers_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The outliers will be read at ", path, "\n")
    }
    outliers <- yaml::read_yaml(
        file = path
    )
    return(outliers)
}

#' @importFrom yaml write_yaml
#' @name td_tools
#' @export
export_td <- function(x, ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("td_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("td_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The td will be written at ", path, "\n")
    }
    yaml::write_yaml(
        x = x,
        file = path
    )
    return(invisible(path))
}

#' @importFrom yaml read_yaml
#' @name td_tools
#' @export
import_td <- function(ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("td_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("td_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The td will be read at ", path, "\n")
    }
    td <- yaml::read_yaml(
        file = path
    )
    return(td)
}
