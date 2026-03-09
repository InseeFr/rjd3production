#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rjd3toolkit
#' @importFrom rjd3workspace read_sai
#' @importFrom rJava .jinit
## usethis namespace: end
NULL

.onLoad <- function(libname, pkgname) {
    print("loaded")

    rJava::.jinit()

    if (! requireNamespace('rjd3toolkit', quietly = TRUE)) stop("Loading rjd3 libraries failed")
    if (! requireNamespace("rjd3tramoseats", quietly = TRUE)) stop("Loading rjd3 libraries failed")
    if (! requireNamespace("rjd3x13", quietly = TRUE)) stop("Loading rjd3 libraries failed")

    print("ici")
    path_jar <- system.file("java", package = "rjd3toolkit")
    .jaddClassPath(path_jar)

    print("là")

    rjd3toolkit::reload_dictionaries()
}
