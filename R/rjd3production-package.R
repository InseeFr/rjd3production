#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rjd3toolkit
#' @importFrom rjd3workspace read_sai
## usethis namespace: end
NULL

.onLoad <- function(libname, pkgname) {
    print("loaded")
    if (! requireNamespace('rjd3toolkit', quietly = TRUE)) stop("Loading rjd3 libraries failed")
    if (! requireNamespace("rjd3tramoseats", quietly = TRUE)) stop("Loading rjd3 libraries failed")
    if (! requireNamespace("rjd3x13", quietly = TRUE)) stop("Loading rjd3 libraries failed")
    rjd3toolkit::reload_dictionaries()
}
