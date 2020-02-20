#' Shiny UI
#'
#' @return user interface
#' @export
app_ui <- function() {
  shiny::tagList(
    # Leave this function for adding external resources
    qmongr::add_external_resources(),
    # List the first level UI elements here
    shiny::tagList(
      mod_quality_overview_ui("quality_overview_ui_1")
    )
  )
}

#' attaches external resources to the head tag
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
      rel = "stylesheet", type = "text/css", href = "www/qmongr.css"
    )
  )
}
