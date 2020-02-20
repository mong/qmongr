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
  shiny::callModule(qmongr::mod_kvalitetsoverview_server,
                    "kvalitetsoverview_ui_1")
}
