#' @importFrom tools file_path_sans_ext
#' @importFrom tools file_ext
#' @importFrom checkmate assert_character
prepare_path <- function(path = NULL, object = "outliers") {
    checkmate::assert_character(object, len = 1L)

    if (is.null(path)) {
        path_dir <- file.path(tempdir(), "regression")
        if (!dir.exists(path_dir)) {
            dir.create(path_dir, showWarnings = FALSE)
        }
        path <- file.path(
            path_dir,
            paste0(object, "-", sample.int(10000L, size = 1L), ".yaml")
        )
        warning(
            "The path is missing. ",
            "The table will be written at ",
            path,
            call. = FALSE
        )
    } else if (dir.exists(path)) {
        path <- normalizePath(path, mustWork = TRUE)
        path <- file.path(
            path,
            paste0(object, "-", sample.int(10000L, size = 1L), ".yaml")
        )
    } else if (file.exists(path)) {
        if (!tools::file_ext(path) %in% c("yml", "yaml")) {
            new_file_name <- path |>
                basename() |>
                tools::file_path_sans_ext() |>
                paste0(... = _, ".yaml")
            path <- file.path(dirname(path), new_file_name)
            warning(
                "Only .yml and .yaml files are accepted.",
                "The table will be written at ",
                path,
                call. = FALSE
            )
        }
    } else if (nzchar(tools::file_ext(path))) {
        if (!dir.exists(dirname(path))) {
            dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
        }
        if (!tools::file_ext(path) %in% c("yml", "yaml")) {
            new_file_name <- path |>
                basename() |>
                tools::file_path_sans_ext() |>
                paste0(... = _, ".yaml")
            path <- file.path(dirname(path), new_file_name)
            warning(
                "Only .yml and .yaml files are accepted.",
                "The table will be written at ",
                path,
                call. = FALSE
            )
        }
    } else {
        dir.create(path, showWarnings = FALSE, recursive = TRUE)
        path <- file.path(
            path,
            paste0(object, "-", sample.int(10000L, size = 1L), ".yaml")
        )
    }
    return(path)
}

#' @importFrom checkmate assert_data_frame
#' @importFrom checkmate assert_date
#' @importFrom checkmate assert_flag
#' @importFrom yaml write_yaml
#' @family regression tools
#' @rdname regression_tools
#' @export
export_outliers <- function(outliers, path = NULL, verbose = TRUE) {
    checkmate::assert_flag(verbose)
    checkmate::assert_data_frame(outliers, types = rep("character", 4L))
    stopifnot(outliers$type %in% c("AO", "LS", "TC", "SO"))
    checkmate::assert_date(base::as.Date(outliers$date, origin = "1970-01-01"))
    path <- prepare_path(path, "outliers")

    if (verbose) {
        cat("The outliers table will be written at ", path, "\n")
    }
    yaml::write_yaml(x = outliers, file = path)
    return(invisible(path))
}

#' @importFrom checkmate assert_flag
#' @importFrom yaml read_yaml
#' @importFrom tools file_ext
#' @family regression tools
#' @rdname regression_tools
#' @export
import_outliers <- function(path, verbose = TRUE) {
    checkmate::assert_flag(verbose)
    path <- normalizePath(path, mustWork = TRUE)
    if (!file.exists(path)) {
        stop("The file ", path, " doesn't exist.", call. = FALSE)
    }
    if (!tools::file_ext(path) %in% c("yml", "yaml")) {
        stop("Only .yml and .yaml files are accepted.", call. = FALSE)
    }

    if (verbose) {
        cat("The outliers table will be read at ", path, "\n")
    }
    outliers <- as.data.frame(yaml::read_yaml(file = path))
    return(outliers)
}

#' @importFrom checkmate assert_flag
#' @importFrom checkmate assert_data_frame
#' @importFrom yaml write_yaml
#' @family regression tools
#' @rdname regression_tools
#' @export
export_td <- function(td, path = NULL, verbose = TRUE) {
    checkmate::assert_flag(verbose)
    checkmate::assert_data_frame(td, types = rep("character", 2L))
    path <- prepare_path(path, "td")

    if (verbose) {
        cat("The td table will be written at", path, "\n")
    }
    yaml::write_yaml(x = td, file = path)
    return(invisible(path))
}

#' @importFrom checkmate assert_flag
#' @importFrom yaml read_yaml
#' @importFrom tools file_ext
#' @family regression tools
#' @rdname regression_tools
#' @export
import_td <- function(path, verbose = TRUE) {
    checkmate::assert_flag(verbose)
    path <- normalizePath(path, mustWork = TRUE)
    if (!file.exists(path)) {
        stop("The file ", path, " doesn't exist.", call. = FALSE)
    }
    if (!tools::file_ext(path) %in% c("yml", "yaml")) {
        stop("Only .yml and .yaml files are accepted.", call. = FALSE)
    }

    if (verbose) {
        cat("The td table will be read at ", path, "\n")
    }
    td <- as.data.frame(yaml::read_yaml(file = path))
    return(td)
}
