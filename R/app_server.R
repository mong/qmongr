#'Server logic
#'
#' Server side logic of the application
#'
#' @param input shiny input components
#' @param output shiny output components
#' @param session the shiny session parameter
#'
#' @return ignored
#' @export
app_server <- function(input, output, session) {
  #All the processed data
  app_data <- qmongr::get_data()
  register_data <- app_data[["register_data"]]
  grouped_by_hf <- app_data[["grouped_by_hf"]]
  grouped_by_rhf <- app_data[["grouped_by_rhf"]]
  grouped_by_hospital <- app_data[["grouped_by_hospital"]]
  national_data <- app_data[["national_data"]]
  tu_names <- app_data[["tu_names"]]
  #data passed to js
  output$json <- shiny::reactive({
      paste(
        "<script> var  description = ",
          jsonlite::toJSON(register_data$description, na = "null"), ";",
          "var indicator_hosp =", jsonlite::toJSON(grouped_by_hospital), ";",
          "var indicator_hf =", jsonlite::toJSON(grouped_by_hf), ";",
          "var indicator_rhf =", jsonlite::toJSON(grouped_by_rhf), ";",
          "var indicator_nat =", jsonlite::toJSON(national_data), ";",
          "var tu_names =", jsonlite::toJSON(tu_names), ";",
        "</script>",
        shiny::tags$script(src = "www/static/js/2.295d41d0.chunk.js"),
        shiny::tags$script(src = "www/static/js/main.0d2c2a86.chunk.js"),
        shiny::tags$script(src = "www/static/js/runtime-main.7678d803.js")
      )
    })
}
