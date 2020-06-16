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
sidebar_qo_ui <- function(id, list_of_med_fields) {
  ns <- NS(id)
  fag_id <- lapply(
    names(list_of_med_fields),
    ns
  )
  category <- lapply(
    list_of_med_fields,
    function(x) x$name
  )

  num_fagomr <- lapply(
      list_of_med_fields,
      function(x) x$num
    )  %>% as.data.frame()

  overview_list(
    id = fag_id,
    category_name = category,
    nr_of_reg = num_fagomr,
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
