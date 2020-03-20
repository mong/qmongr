#' Server side logic of the application
#'
#' @param input shiny input components
#' @param output shiny output components
#' @param session the shiny session parameter
#'
#' @return ignored
#' @export
app_server <- function(input, output, session) {
  # List the first level callModules here
  shiny::callModule(quality_overview_server,
                    "quality_overview_ui_1")
}
