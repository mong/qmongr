# Top navbar UI

#' Top navbar
#'
#' Table navigation bar
#' module server, user interface and server functions.
#' Lets user search for RHFs, HFs or hospitals, look at specific
#' years and get version information about the app
#'
#' @param id shiny id
#' @param config configuration file
#' @param app_data provide the treatment units
#' @name top_navbar
#' @aliases top_navbar_ui top_navbar_server
NULL

#' @rdname top_navbar
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
top_navbar_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::column(
      width = 3,
      NULL
    ),
    shiny::column(
      width = 5,
      shiny::uiOutput(outputId = ns("treatment_unit"))
    ),
    shiny::column(
      width = 2,
      shiny::uiOutput(outputId = ns("year"))
    ),
    shiny::column(
      width = 2,
      shiny::uiOutput(outputId = ns("app_info"))
    )
  )
}

#' @rdname top_navbar
#' @export
#' @keywords internal
top_navbar_server <- function(id, app_data, config) {
  shiny::moduleServer(id, function(input, output, session) {
  ns <- session$ns
  # the ns function adds "quality_overview_ui_1--" to the input and
  # output names inside

  #list of treatment units
  choices_treatment <- list(
    "RHF" = app_data[["grouped_by_rhf"]] %>%
      purrr::pluck(config$column$treatment_unit) %>%
      unique() %>%
      stringr::str_sort(locale = config$language),
    "HF" = app_data[["grouped_by_hf"]] %>%
      purrr::pluck(config$column$treatment_unit) %>%
      unique() %>%
      stringr::str_sort(locale = config$language),
    "Sykehus" = app_data[["grouped_by_hospital"]] %>%
      purrr::pluck(config$column$treatment_unit) %>%
      unique() %>%
      stringr::str_sort(locale = config$language))

  output$treatment_unit <- shiny::renderUI({
    shiny::selectizeInput(
      label = NULL,
      inputId = ns("pick_treatment_units"),
      choices =  choices_treatment,
      multiple = TRUE,
      options = list(
        maxItems = config$app_text$max_nr_treatment_units,
        placeholder = config$app_text$menus$unit,
        onInitialize = I('function() { this.setValue(""); }')
      )
    )
  })

  # input years
  output$year <-  shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("pick_year"),
      choices = c(2016, 2017, 2018, 2019) %>%
        sort(decreasing = T)
    )
  })

  #appinfo
  output$app_info <- shiny::renderUI({
    shiny::actionButton(
      inputId = ns("app_info"),
      label = "",
      icon = shiny::icon("info")
    )
  })
  shiny::observeEvent(input$app_info, {
    shinyalert::shinyalert(title = config$app_text$info$title,
                           text = qmongr::version_info(),
                           type = "",
                           closeOnEsc = TRUE, closeOnClickOutside = TRUE,
                           html = TRUE,
                           confirmButtonText = qmongr::no_opt_out_ok())
  })
  #selected treatment units
  return(
    selected_units = shiny::reactive({
      selected_units <- list()
      selected_units[[config$treatment_unit_level$rhf]] <- input$pick_treatment_units[
        shiny::req(input$pick_treatment_units) %in%
          choices_treatment$RHF]
      selected_units[[config$treatment_unit_level$hf]] <- input$pick_treatment_units[
        shiny::req(input$pick_treatment_units) %in%
          choices_treatment$HF]
      selected_units[[config$treatment_unit_level$hospital]] <- input$pick_treatment_units[
      shiny::req(input$pick_treatment_units) %in%
        choices_treatment$Sykehus]
      selected_units[["year"]] <- input$pick_year
    return(selected_units)
    })
  )
  })
}
