# Module UI

#' Quality overview
#'
#' Quality overview module server, user interface and server functions.
#' Present results of search to user as table
#'
#' @param id shiny id
#' @name quality_overview
#' @aliases quality_overview_ui quality_overview_server
NULL

#' @rdname quality_overview
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
quality_overview_ui <- function(id) {
  tagList(
    shiny::tags$div(id = "root"),
    shiny::tags$script(src = "www/static/js/2.6f4bb256.chunk.js"),
    shiny::tags$script(src = "www/static/js/main.2d5ba336.chunk.js"),
    shiny::tags$script(src = "www/static/js/runtime-main.7678d803.js")
  )
}

# Module Server

#' @rdname quality_overview
#' @importFrom rlang .data
#' @export
#' @keywords internal

quality_overview_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    #All the processed data
    app_data <- qmongr::get_data()
    register_data <- app_data[["register_data"]]
    grouped_by_hf <- app_data[["grouped_by_hf"]]
    grouped_by_rhf <- app_data[["grouped_by_rhf"]]
    grouped_by_hospital <- app_data[["grouped_by_hospital"]]
    national_data <- app_data[["national_data"]]
    tu_names <- app_data[["tu_names"]]

    shiny::observe({
      session$sendCustomMessage(
        type = "tu_names",
        message =  jsonlite::toJSON(tu_names)
      )
    })
    shiny::observe({
      session$sendCustomMessage(
        type = "description",
        message =  jsonlite::toJSON(register_data$description, na = "null")
      )
    })
    shiny::observe({
      session$sendCustomMessage(
        type = "nation",
        message =  jsonlite::toJSON(national_data)
      )
    })
    shiny::observe({
      session$sendCustomMessage(
        type = "hospital",
        message =  jsonlite::toJSON(grouped_by_hospital)
      )
    })
    shiny::observe({
      session$sendCustomMessage(
        type = "hf",
        message =  jsonlite::toJSON(grouped_by_hf)
      )
    })
    shiny::observe({
      session$sendCustomMessage(
        type = "rhf",
        message =  jsonlite::toJSON(grouped_by_rhf)
      )
    })
  })
}
