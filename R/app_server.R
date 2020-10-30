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
  
  shiny::observe({
    session$sendCustomMessage(
      type = "tu_names",
      message =  jsonlite::toJSON(tu_names)
    )
 
    session$sendCustomMessage(
      type = "description",
      message =  jsonlite::toJSON(register_data$description, na = "null")
    )
  
    session$sendCustomMessage(
      type = "nation",
      message =  jsonlite::toJSON(national_data)
    )
  
    session$sendCustomMessage(
      type = "hospital",
      message =  jsonlite::toJSON(grouped_by_hospital)
    )
 
    session$sendCustomMessage(
      type = "hf",
      message =  jsonlite::toJSON(grouped_by_hf)
    )
 
    session$sendCustomMessage(
      type = "rhf",
      message =  jsonlite::toJSON(grouped_by_rhf)
    )
  })
}
