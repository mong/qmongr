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
            width = 3,
            shiny::tags$h3(config$app_text$menus$year)
          ),
          shiny::column(
            width = 3,
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

  ns <- session$ns
  config <- qmongr::get_config()
  output$qi_table <- shiny::renderUI({
    filter_list <-  list(
      ShNavn = shiny::req(input$pick_treatment_unit),
      Aar = shiny::req(input$pick_year)
    )
   qi_by_treatment_unit <-  qmongr::load_data() %>%
      qmongr::filter_data(filter_list) %>%
      qmongr::aggregate_data() %>%
      qmongr::compute_indicator()
   qi_national <- qmongr::load_data("indicator")[["indicator"]] %>%
       qmongr::compute_national_indicator()

   qi_joined <- qi_by_treatment_unit %>%
     dplyr::inner_join(
       qi_national,
       by = c(.data[["Aar"]],
              .data[["kvalIndID"]])
    )
   qmongr::qi_table(qi_joined, input$pick_treatment_unit, config)
  })

   choices_treatment_unit <- shiny::reactive({
      qmongr::load_data() %>%
      qmongr::filter_data() %>%
      qmongr::aggregate_data() %>%
      qmongr::compute_indicator() %>%
      dplyr::filter(.data[["total"]] > 5)
   })


    choices_year <- shiny::reactive({
      choices_treatment_unit() %>%
      dplyr::filter(
        .data[["ShNavn"]] == shiny::req(input$pick_treatment_unit)
      )
   })


  output$treatment_unit <- shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("pick_treatment_unit"),
      choices = choices_treatment_unit()[["ShNavn"]] %>%
        unique() %>%
        sort()
    )
  })

 output$year <-  shiny::renderUI({
   shiny::selectInput(
      label = NULL,
      inputId = ns("pick_year"),
      choices = choices_year()[["Aar"]] %>%
        unique() %>%
        sort()

    )
  })


}
