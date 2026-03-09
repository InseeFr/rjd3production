#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rjd3toolkit
#' @import rJava
#' @importFrom rjd3workspace read_sai
#' @importFrom rJava .jinit .jaddClassPath .jpackage
## usethis namespace: end
NULL

.onLoad <- function(libname, pkgname) {
    print("loaded")
    rJava::.jpackage(pkgname, lib.loc=libname)
    print("after")

    # if (! requireNamespace('rjd3toolkit', quietly = TRUE)) stop("Loading rjd3 libraries failed")
    # if (! requireNamespace("rjd3tramoseats", quietly = TRUE)) stop("Loading rjd3 libraries failed")
    # if (! requireNamespace("rjd3x13", quietly = TRUE)) stop("Loading rjd3 libraries failed")

    library("rjd3toolkit")

    rJava::.jinit()
    print("ici")
    path_jar <- system.file("java", package = "rjd3toolkit")
    rJava::.jaddClassPath(path_jar)

    print("là")

    rjd3toolkit::reload_dictionaries()

    print("enfin")
}
