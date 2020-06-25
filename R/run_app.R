#' Run
#'
#' Run the Shiny Application, use app_ui and app_server as
#' ui and server respectively
#' @seealso \code{\link{app_ui}}, \code{\link{app_server}}
#'
#' @export
#'
run_app <- function() {
  shiny::shinyApp(
    ui = qmongr::app_ui, server = qmongr::app_server
  )
}
