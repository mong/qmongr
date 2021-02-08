#' Shiny UI
#'
#' Constructs Shiny user interface for use in run_app
#'
#' @return user interface
#' @export
app_ui <- function() {
  shiny::addResourcePath(
    "www", system.file("app/www", package = "qmongr")
  )
  shiny::tagList(
    shiny::tags$head(
      shiny::tags$link(
        rel = "icon", type = "image/png", href = "www/hn.png"
      ),
      shiny::tags$link(
        rel = "stylesheet", type = "text/css", href = "www/fontawesome/css/all.min.css"
      ),
      shiny::tags$link(
        rel = "stylesheet", type = "text/css", href = "www/fontawesome/css/v4-shims.min.css"
      ),
      shiny::tags$link(
        rel = "stylesheet", type = "text/css", href = "www/static/css/main.acc4edd8.chunk.css"
      ),
      shiny::tags$script(type = "application/javascript", src = "www/iframeResizer.contentWindow.min.js")
    ),
    shiny::tags$div(id = "root"),
    shiny::tags$script(type = "application/javascript", src = "www/static/js/2.314f7489.chunk.js"),
    shiny::tags$script(type = "application/javascript", src = "www/static/js/main.52e8a3f8.chunk.js"),
    shiny::tags$script(type = "application/javascript", src = "www/static/js/runtime-main.e823afca.js")
  )
}
