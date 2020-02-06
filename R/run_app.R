#' Run the Shiny Application
#'
#' @export
#'
run_app <- function() {
  shiny::shinyApp(
    ui = qmongr::app_ui, server = qmongr::app_server
  )
}

