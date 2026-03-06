#' @title Extract all series from a SA-Item
#'
#' @description
#' Extracts all available time series (pre-adjustment, decomposition, and final)
#' from a seasonal adjustment item (`jsai`) inside a JDemetra+ workspace.
#'
#' @param jsai A Java Seasonal Adjustment Item object, typically obtained via
#'   [jsap_sai()] after opening and computing a workspace with [jws_open()]
#'   and [jws_compute()].
#'
#' @return A `data.frame` with columns:
#' - `SAI`: name of the SAI,
#' - `series`: the type of series (e.g. `"y"`, `"sa"`, `"trend"`),
#' - `date`: observation dates,
#' - `value`: numeric values of the series.
#'
#' @examples
#' \dontrun{
#' library("rjd3workspace")
#' path <- file.path(tempdir(), "workspace_RSA3.xml")
#' jws <- jws_open(path)
#' jws_compute(jws)
#' jsap <- jws_sap(jws, 1L)
#' jsai <- jsap_sai(jsap, 1L)
#'
#' df <- get_series(jsai)
#' head(df)
#' }
#'
#' @importFrom rjd3workspace read_sai sai_name
#' @importFrom zoo as.Date
#' @export
get_series <- function(jsai) {
    res <- rjd3workspace::read_sai(jsai)$results
    if (is.null(res)) {
        stop("Please compute your workspace")
    }
    output <- NULL
    all_series <- c(res$preadjust, res$decomposition, res$final)
    for (s in names(all_series)) {
        series <- all_series[[s]]
        if (!is.null(series)) {
            output <- rbind(
                output,
                data.frame(
                    series = s,
                    date = series |> time() |> zoo::as.Date(),
                    value = as.numeric(series)
                )
            )
        }
    }
    return(cbind(SAI = rjd3workspace::sai_name(jsai), output))
}

#' @title Retrieve a SA-Item by its name
#'
#' @description
#' Searches a workspace for a seasonal adjustment item (SAI) whose name matches
#' the user-supplied string and returns the corresponding object.
#'
#' @param jws A Java Workspace object, as returned by [jws_open()] or
#' [jws_new()].
#' @param series_name [character] Name of the SAI to retrieve.
#'
#' @return A Java Seasonal Adjustment Item object (`jsai`).
#'
#' @examples
#' \dontrun{
#' path <- file.path(tempdir(), "workspace_RSA3.xml")
#' jws <- jws_open(path)
#' jws_compute(jws)
#'
#' jsai <- get_jsai_by_name(jws, "series_1")
#' df <- get_series(jsai)
#' head(df)
#' }
#' @importFrom rjd3workspace jws_sap sap_sai_names jsap_sai
#'
#' @export
get_jsai_by_name <- function(jws, series_name) {
    jsap <- rjd3workspace::jws_sap(jws, idx = 1L)
    sai_names <- rjd3workspace::sap_sai_names(jsap)
    id <- which(sai_names == series_name)
    if (length(id) == 0) {
        stop("No SAI are named after ", series_name)
    }
    if (length(id) > 1) {
        stop("More than one SAI is named after ", series_name)
    }
    return(rjd3workspace::jsap_sai(jsap, idx = id))
}

#' @title Compare series across workspaces
#'
#' @description
#' Reads multiple JDemetra+ workspaces and extracts comparable series
#' (by SAI and series type), returning them in a tidy format.
#' This is particularly useful to compare results across different
#' specifications (e.g. RSA3 vs RSA5).
#'
#' @param ... [character] Workspace file paths.
#' @param series_names [character] Vector of SAI names to compare.
#'
#' @return A `data.frame` with columns:
#' - `ws`: workspace name (derived from file basename),
#' - `SAI`: SAI name,
#' - `series`: type of series,
#' - `date`: observation date,
#' - `value`: numeric value.
#'
#' @examples
#' \dontrun{
#' # Two demo workspaces (RSA3 and RSA5)
#' path1 <- file.path(tempdir(), "workspace_RSA3.xml")
#' path2 <- file.path(tempdir(), "workspace_RSA5.xml")
#'
#' df <- compare(path1, path2, series_names = "series_1")
#' head(df)
#' }
#'
#' @importFrom rjd3workspace jws_open jws_sap sap_sai_names jws_compute
#' @importFrom tools file_path_sans_ext
#' @export
compare <- function(..., series_names) {
    ws_paths <- list(...) |>
        lapply(normalizePath)

    if (length(ws_paths) == 0L) {
        stop("There are no paths provided")
    }

    if (missing(series_names)) {
        series_names <- ws_paths[[1L]] |>
            rjd3workspace::jws_open() |>
            rjd3workspace::jws_sap(idx = 1L) |>
            rjd3workspace::sap_sai_names()
    }

    output <- NULL
    for (ws_path in ws_paths) {
        jws <- rjd3workspace::jws_open(ws_path)
        ws_name <- ws_path |> basename() |> tools::file_path_sans_ext()
        rjd3workspace::jws_compute(jws)
        for (series_name in series_names) {
            series <- get_jsai_by_name(jws = jws, series_name = series_name) |>
                get_series()
            output <- rbind(output, cbind(ws = ws_name, series))
        }
    }
    return(output)
}

#' @title Run the Shiny comparison app
#'
#' @description
#' Launches an interactive Shiny application to explore and compare
#' seasonal adjustment results stored in a `data.frame` returned by [compare()].
#'
#' @param data A `data.frame` returned by [compare()], containing
#'   the columns `ws`, `SAI`, `series`, `date`, and `value`.
#' @param ... Additional arguments passed to [shiny::shinyApp()].
#'
#' @return Runs a Shiny app in the R session (no return value).
#'
#' @examples
#' \dontrun{
#' df <- compare(path1, path2)
#' run_app(df)
#' }
#'
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel selectInput
#' @importFrom shiny checkboxInput br downloadButton h4 uiOutput reactive
#' @importFrom shiny renderUI downloadHandler shinyApp
#' @importFrom dygraphs dygraphOutput renderDygraph dygraph
#' @importFrom tidyr pivot_wider
#' @importFrom flextable flextable autofit htmltools_value
#' @importFrom utils write.csv
#'
#' @export
run_app <- function(data, ...) {
    stopifnot(c("ws", "SAI", "series", "date", "value") %in% names(data))

    ui <- shiny::fluidPage(
        shiny::titlePanel("Comparateur de s\u00e9ries"),
        shiny::sidebarLayout(
            shiny::sidebarPanel(
                shiny::selectInput(
                    "sai",
                    "Choisir un SAI :",
                    choices = unique(data$SAI),
                    selected = unique(data$SAI)[1]
                ),
                shiny::selectInput(
                    "serie",
                    "Choisir une s\u00e9rie :",
                    choices = unique(data$series),
                    selected = unique(data$series)[1]
                ),
                shiny::checkboxInput(
                    "filter_by_sai",
                    "Filtrer par SAI",
                    value = TRUE
                ),
                shiny::checkboxInput(
                    "filter_by_serie",
                    "Filtrer par s\u00e9rie",
                    value = TRUE
                ),
                shiny::br(),
                shiny::downloadButton(
                    "export_csv",
                    "Exporter le tableau en CSV"
                )
            ),
            shiny::mainPanel(
                dygraphs::dygraphOutput("plot", height = "400px"),
                shiny::br(),
                shiny::h4("Tableau des donn\u00e9es affich\u00e9es"),
                shiny::uiOutput("table_ui") # l’objet HTML qui contiendra le flextable
            )
        )
    )

    server <- function(input, output, session) {
        # Données filtrées
        filtered_data <- shiny::reactive({
            d <- data
            if (input$filter_by_sai) {
                d <- d[d$SAI == input$sai, ]
            }
            if (input$filter_by_serie) {
                d <- d[d$series == input$serie, ]
            }
            d
        })

        # Données pivotées (communes au graphique et au tableau)
        data_wide <- shiny::reactive({
            d <- filtered_data()
            d_wide <- tidyr::pivot_wider(
                d,
                id_cols = "date",
                names_from = "ws",
                values_from = "value"
            )
            d_wide[order(d_wide$date), ]
        })

        # Graphique dygraphs
        output$plot <- dygraphs::renderDygraph({
            dygraphs::dygraph(
                data_wide(),
                main = paste("SAI:", input$sai, "| S\u00e9rie:", input$serie)
            )
        })

        # Tableau flextable
        output$table_ui <- shiny::renderUI({
            d_wide <- data_wide()
            # Création du flextable
            ft <- flextable::flextable(d_wide)
            ft <- flextable::autofit(ft)
            # Conversion en HTML pour affichage dans Shiny
            flextable::htmltools_value(ft)
        })

        # Export CSV
        output$export_csv <- shiny::downloadHandler(
            filename = function() {
                paste0("table_", input$sai, "_", input$serie, ".csv")
            },
            content = function(file) {
                utils::write.csv(data_wide(), file, row.names = FALSE)
            }
        )
    }

    shiny::shinyApp(ui, server, ...)
}
