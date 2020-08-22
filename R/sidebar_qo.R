# sidebar quality overview

#' Sidebar quality overview
#'
#' Sidebar quality overview module server, user interface and server functions.
#' Lets user filter by medical field
#'
#' @param id shiny id
#' @param list_of_med_fields List of medical fields, with number of indicators per field.
#' @param register_data_description register_data_description
#' @name sidebar_qo
#' @aliases sidebar_qo_ui sidebar_qo_server
NULL

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

  med_field_list(
    id = fag_id,
    category_name = category,
    nr_of_reg = num_fagomr,
    all_id = ns("alle")
  )
}

#' @rdname sidebar_qo
#' @export
#' @keywords internal
sidebar_qo_server <- function(id, register_data_description, config) {
  shiny::moduleServer(id, function(input, output, session) {

  filter_indicator <- shiny::reactiveValues()
  shiny::observe({
    fagomr <- names(qmongr::fagomr)
    clicked_register <- lapply(
      fagomr,
      function(x) {
        shiny::observeEvent(
          input[[x]], {
            clicked_reg <- qmongr::fagomr[[x]][["key"]]
            filter_indicator$indicator <- register_data_description %>%
              dplyr::filter(
                .data[[config$column$registry_short_name]] %in% clicked_reg
              ) %>%
              purrr::pluck(config$column$id) %>%
              unique()
          }
        )
      }
    )
    shiny::observeEvent(
      input$alle, {
        filter_indicator$indicator <- register_data_description %>%
          purrr::pluck(config$column$id) %>%
          unique()
      })
  })
  return(
    indicator <- shiny::reactive({
      if (rlang::is_empty(filter_indicator$indicator)) {
        filter_indicator$indicator <- register_data_description %>%
          purrr::pluck(config$column$id) %>%
          unique()
      }
      filter_indicator$indicator
    })
  )
  })
}
