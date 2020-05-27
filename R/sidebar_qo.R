# sidebar quality overview

#' @title   sidebar
#' @description  A shiny Module.
#'
#' @param id shiny id
#'
#' @rdname sidebar_qo
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
sidebar_qo_ui <- function(id) {
  ns <- NS(id)
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
}

#' @rdname sidebar_qo
#' @param register_data_description register_data_description
#' @export
#' @keywords internal
sidebar_qo_server <- function(id, register_data_description) {
  shiny::moduleServer(id, function(input, output, session) {

  filter_indicator <- shiny::reactiveValues()
  shiny::observe({
    fagomr <- names(qmongrdata::fagomr)
    clicked_register <- lapply(
      fagomr,
      function(x) {
        shiny::observeEvent(
          input[[x]], {
            clicked_reg <- qmongrdata::fagomr[[x]][["key"]]
            filter_indicator$indicator <- register_data_description %>%
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
        filter_indicator$indicator <- register_data_description %>%
          purrr::pluck("IndID") %>%
          unique()
      })
  })
  return(
    indicator <- shiny::reactive({
      if (rlang::is_empty(filter_indicator$indicator)) {
        filter_indicator$indicator <- register_data_description %>%
          purrr::pluck("IndID") %>%
          unique()
      }
      filter_indicator$indicator
    })
  )
  })
}
