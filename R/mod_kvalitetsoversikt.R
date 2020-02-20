# Module UI

#' @title   mod_kvalitetsoverview_ui and mod_kvalitetsoverview_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_kvalitetsoverview
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_kvalitetsoverview_ui <- function(id) {
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

#' @rdname mod_kvalitetsoverview
#' @importFrom rlang .data
#' @export
#' @keywords internal

mod_kvalitetsoverview_server <- function(input,
                                         output,
                                         session) {

  ns <- session$ns
  output$qi_table <- shiny::renderUI({
    filter_list <-  list(
      ShNavn = shiny::req(input$velg_behandlingsenhet),
      Aar = shiny::req(input$velg_aar)
    )
   qi_by_sh <-  qmongr::load_data() %>%
      qmongr::filter_data(filter_list) %>%
      qmongr::aggregate_data() %>%
      qmongr::compute_indicator()
   qi_national <- qmongr::load_data("indicator")[["indicator"]] %>%
       qmongr::compute_national_indicator()

   qi_joined <- qi_by_sh %>%
     dplyr::inner_join(
       qi_national,
       by = c(.data[["Aar"]],
              .data[["kvalIndID"]])
    )
   qmongr::qi_table(qi_joined, input$velg_behandlingsenhet)
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
