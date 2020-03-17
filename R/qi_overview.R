#' Makes html list of clickable links
#' @param id unique id for each link
#' @param category_name the names of a category that will
#'  be displayed
#' @param nr_of_reg the nr of registers included in a category
#' @param all_id the inputId for the Alle actionLink
#' @importFrom shiny tags
#' @return html tags
overview_list <- function(id, category_name, nr_of_reg, all_id) {
  tags$ul(
    tags$li(
      class = "title",
      tags$div(
        class = "category_and_number",
        tags$div(
          class = "qi_category",
          shiny::actionLink(
            inputId = all_id,
            shiny::tags$h2("Alle")
          )
        ),
        tags$div(
          class = "nr_of_reg",
          tags$div(
            class = "nr_of_reg_text",
            sum(nr_of_reg)
          )
        )
      )
    ),
    purrr::pmap(
      list(
        category_name,
        id,
        nr_of_reg
      ),
      function(name, id, nr_of_reg) {
        tags$li(
          tags$div(
            class = "category_and_number",
            tags$div(
              class = "qi_category",
              shiny::actionLink(
                class = "qi_category_link",
                inputId = paste0(id),
                label = paste0(name)
              )
            ),
            tags$div(
              class = "nr_of_reg",
              tags$div(
                class = "nr_of_reg_text",
                nr_of_reg
              )
            )
          )
        )
      }
    )
  )
}
