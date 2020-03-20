# Table legend UI

#' @title   Table legend
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param config configuration file
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname table_legend
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
table_legend_ui <- function(id, config) {
  ns <- NS(id)
  shiny::tags$div(
    class = "table_legend",
    shiny::tags$div(
      class = "high",
      shiny::actionLink(
        inputId = ns("legend_high"),
        label = shiny::tags$p(
          shiny::icon("fas fa-circle"),
          config$app_text$indicators$high
        )
      )
    ),
    shiny::tags$div(
      class = "moderate",
      shiny::actionLink(
        inputId = ns("legend_mod"),
        label = shiny::tags$p(
          shiny::icon("fas fa-adjust"),
          config$app_text$indicators$moderate
        )
      )
    ),
    shiny::tags$div(
      class = "low",
      shiny::actionLink(
        inputId = ns("legend_low"),
        label = shiny::tags$p(
          shiny::icon("circle-o"),
          config$app_text$indicators$low
        )
      )
    )
  )
}

#' @rdname table_legend
#' @export
#' @keywords internal
table_legend_server <- function(input, output, session) {

  filter_indicator <- shiny::reactiveValues()
  #filtering by achievement levels
  shiny::observe({
    clicked_level <- list(F, F, F)
    names(clicked_level) <- c("legend_high", "legend_mod", "legend_low")
    filter_indicator$level <- list("H", "M", "L", "undefined")

    level_buttons <- lapply(
      names(clicked_level),
      function(button) {
        shiny::observeEvent(
          shiny::req(input[[button]]), {
            if (clicked_level[[button]]) {
              clicked_level <<- list(F, F, F)
              names(clicked_level) <<- c("legend_high", "legend_mod", "legend_low")
              filter_indicator$level <- list("H", "M", "L", "undefined")
            } else {
              clicked_level <<- list(F, F, F)
              names(clicked_level) <<- c("legend_high", "legend_mod", "legend_low")
              clicked_level[[button]] <<- T
              filter_indicator$level <- list("H", "M", "L")[unlist(clicked_level)]
            }
          }
        )
      }
    )
  })
  return(
    level <- shiny::reactive({
      filter_indicator$level
    })
  )
}
