# Module UI

#' @title   mod_quality_overview_ui and mod_quality_overview_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_quality_overview
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_quality_overview_ui <- function(id) {
  ns <- shiny::NS(id)
  config <- qmongr::get_config()
  tagList(
    shiny::fluidPage(
      shiny::tags$div(
        class = "treatment_unit",
        shiny::fluidRow(
          shiny::column(
            width = 3,
            shiny::tags$h3(config$app_text$menus$unit)
          ),
          shiny::column(
            width = 3,
            shiny::uiOutput(outputId = ns("treatment_unit"))
          ),
          shiny::column(
            width = 2,
            shiny::tags$h3(config$app_text$menus$year)
          ),
          shiny::column(
            width = 2,
            shiny::uiOutput(outputId = ns("year"))
          )
        )
      ),
      shiny::tags$div(
        class = "table_legend",
        shiny::fluidRow(
          shiny::column(
            width = 7,
            offset = 4,
            shiny::tags$ul(
              shiny::tags$li(class = "high",
                shiny::icon("fas fa-circle"),
                config$app_text$indicators$high),
              shiny::tags$li(class = "moderate",
                shiny::icon("fas fa-adjust"),
                config$app_text$indicators$moderate),
              shiny::tags$li(class = "low",
                shiny::icon("circle-o"),
                config$app_text$indicators$low),
            )
          )
        )
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

#' @rdname mod_quality_overview
#' @importFrom rlang .data
#' @export
#' @keywords internal

mod_quality_overview_server <- function(input,
                                        output,
                                        session) {
  #All the processed data
  ns <- session$ns
  config <- qmongr::get_config()
  register_data <- qmongr::load_data()
  grouped_by_hf <- qmongr::group_data(
    register_data,
    by = config$data$column$unit_name$hf
  ) %>%
    dplyr::left_join(
      register_data[["hospital_name_structure"]] %>%
          dplyr::select(
            .data[[config$data$column$unit_name$hfshort]],
            .data[[config$data$column$unit_id$hf]]
          ) %>%
          unique(),
        by = config$data$column$unit_id$hf
      )
  grouped_by_rhf <- qmongr::group_data(
    register_data,
    by = config$data$column$unit_name$rhf
  ) %>%
    dplyr::left_join(
      register_data[["hospital_name_structure"]] %>%
        dplyr::select(
          .data[[config$data$column$unit_name$rhf]],
          .data[[config$data$column$unit_id$rhf]]
        ) %>%
        unique(),
      by = config$data$column$unit_id$rhf
    )
  grouped_by_hospital <- qmongr::group_data(
    register_data,
    by = "hospital"
  ) %>%
    dplyr::left_join(
      register_data[["hospital_name_structure"]] %>%
        dplyr::select(
          .data[[config$data$column$unit_name$sh]],
          .data[[config$data$column$unit_id$sh]]
        ),
      by = c(config$data$column$unit_id$sh),
    ) %>%
    dplyr::filter(!is.na(.data[[config$data$column$unit_name$sh]]))
  national_data <- qmongr::group_data(
    register_data,
    by = ""
  )
  #picked treatment units
  selected_units <- shiny::reactive({
    selected_units <- list()
    selected_units[[config$data$column$unit_name$rhf]] <- input$pick_treatment_units[
      shiny::req(input$pick_treatment_units) %in%
        choices_treatment[[config$data$column$unit_name$rhf]]]
    selected_units[[config$data$column$unit_name$hf]] <- input$pick_treatment_units[
      shiny::req(input$pick_treatment_units) %in%
        choices_treatment$HF]
    selected_units[[config$data$column$unit_name$sh]] <- input$pick_treatment_units[
      shiny::req(input$pick_treatment_units) %in%
        choices_treatment$Sykehus]
    return(selected_units)
  })
  #filtered data that makes up the table content
  filtered_data <- shiny::reactive({
    if (rlang::is_empty(filter_indicator$indicator)) {
      filter_indicator$indicator <- register_data[["description"]] %>%
        purrr::pluck("IndID") %>%
        unique()
    }
    selected_data <- list()
    if (!rlang::is_empty(selected_units()[[config$data$column$unit_name$rhf]])) {
      selected_data[[config$data$column$unit_name$rhf]] <- grouped_by_rhf %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$rhf]] %in% selected_units()$RHF,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == input$pick_year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator
        )
    }
    if (!rlang::is_empty(selected_units()$HF)) {
      selected_data[[config$data$column$unit_name$hf]] <- grouped_by_hf %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$hfshort]] %in% selected_units()$HF,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == input$pick_year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator
        )
    }
    if (!rlang::is_empty(selected_units()$Sykehus)) {
      selected_data[[config$data$column$unit_name$sh]] <- grouped_by_hospital %>%
        dplyr::filter(
          .data[[config$data$column$unit_name$sh]] %in% selected_units()$SykehusNavn,
          .data[["count"]] > 5,
          .data[[config$data$column$year]] == input$pick_year,
          .data[[config$data$column$qi_id]] %in% filter_indicator$indicator
        )
    }
    selected_data$national <- national_data %>%
      dplyr::filter(.data[[config$data$column$year]] == input$pick_year)
    return(selected_data)
  })
  #table output
  output$qi_table <- shiny::renderUI({
    if (length(input$pick_year) > 1) {
      return(NULL)
    }
    qmongr::qi_table(filtered_data(), selected_units(), config)
  })
  #list of treatment units
  choices_treatment <- list(
    "RHF" = grouped_by_rhf$RHF %>%
      unique() %>%
      stringr::str_sort(locale = config$language),
    "HF" = grouped_by_hf[[config$data$column$unit_name$hfshort]] %>%
      unique() %>%
      stringr::str_sort(locale = config$language),
    "Sykehus" = grouped_by_hospital$SykehusNavn %>%
      unique() %>%
      stringr::str_sort(locale = config$language))
  output$treatment_unit <- shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("pick_treatment_units"),
      choices =  choices_treatment,
      multiple = TRUE
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
  #filtering by field
  output$qi_overview <- shiny::renderUI({
    id <- lapply(
      names(qmongrdata::fagomr),
      ns
    )
    category <- lapply(
      qmongrdata::fagomr,
      function(x) x$name
    )
    overview_list(
      id = id,
      category_name = category,
      nr_of_reg = sample(1:5, length(category), TRUE),
      all_id = ns("alle")
    )
  })
  filter_indicator <- shiny::reactiveValues()
  shiny::observe({
    fagomr <- names(qmongrdata::fagomr)
    clicked_register <- lapply(
      fagomr,
      function(x) {
       shiny::observeEvent(
         input[[x]], {
            clicked_reg <- qmongrdata::fagomr[[x]][["key"]]
            filter_indicator$indicator <- register_data[["description"]] %>%
              dplyr::filter(
                .data[["Register"]] %in% clicked_reg
              ) %>%
            purrr::pluck("IndID") %>%
            unique()
         }
       )
      }
    )
    shiny::observeEvent(
      input$alle, {
        filter_indicator$indicator <- register_data[["description"]] %>%
        purrr::pluck("IndID") %>%
        unique()
      })
   })
}
