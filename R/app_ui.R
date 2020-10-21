#' Shiny UI
#'
#' Constructs Shiny user interface for use in run_app
#'
#' @return user interface
#' @export
app_ui <- function() {
  shiny::tagList(
    # Leave this function for adding external resources
    qmongr::add_external_resources(),
    # List the first level UI elements here
    shiny::tagList(
      quality_overview_ui("quality_overview_ui_1")
    )
  )
}
#' Attach external resources
#'
#' Attaches external resources to the head tag, used
#' to construct user interface
#'
#' @export

add_external_resources <- function() {
   shiny::addResourcePath(
    "www", system.file("app/www", package = "qmongr")
   )
  shiny::tags$head(
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    shiny::tags$link(
      rel = "stylesheet", type = "text/css", href = "www/fontawesome/css/all.min.css"
    ),
    shiny::tags$link(
      rel = "stylesheet", type = "text/css", href = "www/fontawesome/css/v4-shims.min.css"
    ),
    shiny::tags$link(
      rel = "stylesheet", type = "text/css", href = "www/static/css/main.6aa8215a.chunk.css"
    ),
    shiny::tags$script(src = "www/iframeResizer.contentWindow.min.js")
  )
}
