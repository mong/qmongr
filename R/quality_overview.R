# Module UI

#' @title   quality_overview_ui and quality_overview_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname quality_overview
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
quality_overview_ui <- function(id) {
  ns <- shiny::NS(id)
  config <- qmongr::get_config()
  tagList(
    shiny::fluidPage(
      shinyalert::useShinyalert(),
      shiny::tags$div(
        class = "treatment_unit",
        shiny::fluidRow(
          top_navbar_ui("quality_overview_ui_1")
        )
      ),
      table_legend_ui(
        "quality_overview_ui_1",
        config = config
      ),
      shiny::fluidRow(
        shiny::column(
          offset = 1,
          width = 2,
          shiny::uiOutput(
            outputId = ns("qi_overview")
          )
        ),
        shiny::column(
          width = 8,
          shiny::uiOutput(
            outputId = ns("qi_table")
          )
        )
      )
    )
  )
}

# Module Server

#' @rdname quality_overview
#' @importFrom rlang .data
#' @export
#' @keywords internal

quality_overview_server <- function(input,
                                        output,
                                        session) {
  #All the processed data

  config <- qmongr::get_config()
  app_data <- app_data(config)
  register_data <- app_data[["register_data"]]
  grouped_by_hf <- app_data[["grouped_by_hf"]]
  grouped_by_rhf <- app_data[["grouped_by_rhf"]]
  grouped_by_hospital <- app_data[["grouped_by_hospital"]]
  national_data <- app_data[["national_data"]]

  selected_units <- shiny::callModule(
    top_navbar_server,
    NULL,
    app_data = app_data,
    config = config
  )
  filter_indicator <- shiny::reactiveValues()
  filter_indicator$level <- shiny::callModule(
    table_legend_server,
    NULL
  )
  filter_indicator$indicator <- shiny::callModule(
    sidebar_qo_server,
    NULL,
    register_data[["description"]]
  )
  #filtered data that makes up the table content
  filtered_data <- shiny::reactive({

    selected_data <- list()
    if (!rlang::is_empty(selected_units()[[config$data$column$unit_name$rhf]])) {
      selected_data[[config$data$column$unit_name$rhf]] <- grouped_by_rhf %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$rhf]] %in% selected_units()$RHF,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == selected_units()$year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator(),
          .data[["level"]] %in% filter_indicator$level()
        )
    }
    if (!rlang::is_empty(selected_units()$HF)) {
      selected_data[[config$data$column$unit_name$hf]] <- grouped_by_hf %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$hfshort]] %in% selected_units()$HF,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == selected_units()$year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator(),
          .data[["level"]] %in% filter_indicator$level()
        )
    }
    if (!rlang::is_empty(selected_units()$Sykehus)) {
      selected_data[[config$data$column$unit_name$sh]] <- grouped_by_hospital %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$sh]] %in% selected_units()$SykehusNavn,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == selected_units()$year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator(),
          .data[["level"]] %in% filter_indicator$level()
        )
    }
    selected_data$national <- national_data %>%
      dplyr::filter(.data[[config$data$column$year]] == selected_units()$year)
    return(selected_data)
  })
  #table output
  output$qi_table <- shiny::renderUI({
    if (length(selected_units()$year) > 1) {
      return(NULL)
    }
    qmongr::qi_table(filtered_data(), selected_units(), config)
  })


  #filtering by field
  output$qi_overview <- shiny::renderUI({
    sidebar_qo_ui("quality_overview_ui_1")
  })
}
