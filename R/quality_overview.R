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
          width = 3,
          style = "padding-left: 2%;",
          shiny::uiOutput(
            outputId = ns("qi_overview")
          )
        ),
        shiny::column(
          width = 9,
          style = "padding-right: 2%;",
          shiny::uiOutput(
            outputId = ns("qi_table")
          )
        )
      ),
       shiny::htmlOutput(
         ns("json")
       )
    )
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

  config <- qmongr::get_config()
  app_data <- qmongr::agg_data()
  register_data <- app_data[["register_data"]]
  grouped_by_hf <- app_data[["grouped_by_hf"]]
  grouped_by_rhf <- app_data[["grouped_by_rhf"]]
  grouped_by_hospital <- app_data[["grouped_by_hospital"]]
  national_data <- app_data[["national_data"]]

  #add nr to list of med
  num_qi_per_med_field <- shiny::reactive({
    my_func <- function(x, unique_qi) {
      unique_qi <- data.frame(IndID = unique_qi)

      # Mapping table between register and indicator
      qi_reg <- app_data$register_data$description %>%
        dplyr::select(.data[["Register"]], .data[["IndID"]]) %>%
        dplyr::filter(.data[["Register"]] %in% x$key)
      # Add register ID to unique indicators
      link_reg_uniqueqi <- dplyr::inner_join(qi_reg, unique_qi, by = "IndID")

      # Table of number of indicators per register
      num_qi_per_reg <- link_reg_uniqueqi["Register"] %>%
        table() %>%
        as.data.frame(stringsAsFactors = FALSE)

      x$num <- sum(num_qi_per_reg$Freq)
      return(x)
    }

    if (shiny::isTruthy(input$pick_treatment_units)) {
      selected_indicators <- filtered_data()$national$KvalIndID %>% unique
    } else {
      selected_indicators <- national_data %>%
        dplyr::filter(
          .data[[config$data$column$year]] == shiny::req(input$pick_year),
          .data[["level"]] %in% filter_indicator$level()
        ) %>%
        purrr::pluck("KvalIndID") %>%
        unique()
    }

    med_field_list <- lapply(qmongrdata::fagomr, my_func, selected_indicators)
    return(med_field_list)
  })

  selected_units <- top_navbar_server(NULL,
    app_data = app_data,
    config = config
  )
  filter_indicator <- shiny::reactiveValues()
  filter_indicator$level <- table_legend_server(NULL)
  filter_indicator$indicator <- sidebar_qo_server(NULL,
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

    if (!shiny::isTruthy(input$pick_treatment_units)) {
      national_table_data <- national_data %>%
        dplyr::filter(
          .data[[config$data$column$year]] == shiny::req(input$pick_year),
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator(),
          .data[["level"]] %in% filter_indicator$level()
        )
      qmongr::national_table(
        national_table_data,
        app_data$register_data$description,
        config
      )
    } else {
      if (length(shiny::req(selected_units()$year)) > 1) {
        return(NULL)
      }
      qmongr::qi_table(filtered_data(), selected_units(), config)
    }

  })


  #filtering by field
  output$qi_overview <- shiny::renderUI({
    sidebar_qo_ui(id = "quality_overview_ui_1", list_of_med_fields = num_qi_per_med_field())
  })

  #data passed to js
  output$json <- shiny::reactive({
      paste("<script> var  description = ",
            jsonlite::toJSON(app_data$register_data$description, na = "null"), ";",
            "var indicator_hosp =", jsonlite::toJSON(app_data$grouped_by_hospital), ";",
            "var indicator_hf =", jsonlite::toJSON(app_data$grouped_by_hf), ";",
            "var indicator_rhf =", jsonlite::toJSON(app_data$grouped_by_rhf), ";",
            "var indicator_nat =", jsonlite::toJSON(app_data$national_data), ";",
            "; </script>")
  })

  })
}
