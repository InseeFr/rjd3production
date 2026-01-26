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
#' @name cjo_tools
#' @export
export_cjo <- function(x, ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("cjo_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("cjo_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The cjo will be written at ", path, "\n")
    }
    yaml::write_yaml(
        x = x,
        file = path
    )
    return(invisible(path))
}

#' @importFrom yaml read_yaml
#' @name cjo_tools
#' @export
import_cjo <- function(ws_name, path = NULL, verbose = TRUE) {
    if (dir.exists(path)) {
        file_name <- paste0("cjo_", ws_name, ".yaml")
        path <- normalizePath(file.path(path, file_name), mustWork = FALSE)
    }
    if (is.null(path)) {
        file_name <- paste0("cjo_", ws_name, ".yaml")
        path <- normalizePath(
            file.path("regression", file_name),
            mustWork = FALSE
        )
    }
    if (verbose) {
        cat("The cjo will be read at ", path, "\n")
    }
    cjo <- yaml::read_yaml(
        file = path
    )
    return(cjo)
}
