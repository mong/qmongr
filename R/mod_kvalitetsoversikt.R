# Module UI

#' @title   mod_kvalitetsoversikt_ui and mod_kvalitetsoversikt_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_kvalitetsoversikt
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_kvalitetsoversikt_ui <- function(id) {
  ns <- shiny::NS(id)
  tagList(
    shiny::fluidPage(
      shiny::tags$div(
        class = "behandlings_enhet",
        shiny::fluidRow(
          shiny::column(
            width = 3,
            shiny::tags$h3("Velg behandlingsenhet: ")
          ),
          shiny::column(
            width = 3,
            shiny::uiOutput(outputId = ns("behandlingsenhet"))
          ),
          shiny::column(
            width = 3,
            shiny::tags$h3("Velg \u00E5r : ")
          ),
          shiny::column(
            width = 3,
            shiny::uiOutput(outputId = ns("aar"))
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
              shiny::tags$li(class = "hoy",
                shiny::icon("fas fa-circle"),
                "H\u00F8y m\u00E5loppn\u00E5else"),
              shiny::tags$li(class = "moderat",
                shiny::icon("fas fa-adjust"),
                "Moderat m\u00E5loppn\u00E5else"),
              shiny::tags$li(class = "lav",
                shiny::icon("circle-o"),
                "Lav m\u00E5loppn\u00E5else"),
            )
          )
        )
      ),
      shiny::fluidRow(
        shiny::column(
          offset = 1,
          width = 2,
          shiny::uiOutput(
            outputId = ns("ki_oversikt")
          )
        ),
        shiny::column(
          width = 8,
          shiny::uiOutput(
            outputId = ns("ki_tabell")
          )
        )
      )
    )
  )
}

# Module Server

#' @rdname mod_kvalitetsoversikt
#' @importFrom rlang .data
#' @export
#' @keywords internal

mod_kvalitetsoversikt_server <- function(input,
                                         output,
                                         session) {

  ns <- session$ns
  output$ki_tabell <- shiny::renderUI({
    filter_list <-  list(
      ShNavn = shiny::req(input$velg_behandlingsenhet),
      Aar = shiny::req(input$velg_aar)
    )
   ki_by_sh <-  qmongr::load_data() %>%
      qmongr::filter_data(filter_list) %>%
      qmongr::aggregate_data() %>%
      qmongr::compute_indicator()
   ki_national <- qmongr::load_data("indicator")[["indicator"]] %>%
       qmongr::compute_national_indicator()

   ki_joined <- ki_by_sh %>%
     dplyr::inner_join(
       ki_national,
       by = c(.data[["Aar"]],
              .data[["kvalIndID"]])
    )
   qmongr::ki_table(ki_joined, input$velg_behandlingsenhet)
  })

   choices_behandlingsenhet <- shiny::reactive({
      qmongr::load_data() %>%
      qmongr::filter_data() %>%
      qmongr::aggregate_data() %>%
      qmongr::compute_indicator() %>%
      dplyr::filter(.data[["total"]] > 5)
   })


    choices_aar <- shiny::reactive({
      choices_behandlingsenhet() %>%
      dplyr::filter(
        .data[["ShNavn"]] == shiny::req(input$velg_behandlingsenhet)
      )
   })


  output$behandlingsenhet <- shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("velg_behandlingsenhet"),
      choices = choices_behandlingsenhet()[["ShNavn"]] %>%
        unique() %>%
        sort()
    )
  })

 output$aar <-  shiny::renderUI({
   shiny::selectInput(
      label = NULL,
      inputId = ns("velg_aar"),
      choices = choices_aar()[["Aar"]] %>%
        unique() %>%
        sort()

    )
  })


}
