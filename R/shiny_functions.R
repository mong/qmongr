#' html table
#'
#' @param table_data a dataframe to construct a html table from
#' @param enhet the chosen unit
#' @importFrom shiny tags
#' @export
#'

qi_table <- function(table_data, enhet) {
  tags$table(
    tags$thead(
      tags$tr(
        tags$th(
          class = "kvalitetsindicator",
          tags$h2("Kvalitetsindicator")
        ),
        tags$th(
          class = "valgt_enhet",
          tags$h2(enhet)
        ),
        tags$th(
          class = "nasjonalt",
          tags$h2("Nasjonalt")
        ),
      )
    ),
    tags$tbody(
      lapply(
        seq_along(table_data[[1]]),
        function(x) qmongr::table_row_constructor(table_data[x, ]))
    )
  )
}

#'
#'constructs a row of a html table
#'
#' @param dataframe_row a row of a df
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return a row of html table
#' @export
#'
table_row_constructor <- function(dataframe_row) {

  indicator_description <- qmongr::load_data("description")[["description"]]
  indicator_id <- dataframe_row[["kvalIndID"]]
  indicator_description <- indicator_description %>%
    dplyr::filter(.data[["IndID"]] ==  indicator_id)
  reg_name <- indicator_description[["Register"]]
  indicator_title <- indicator_description[["IndTittel"]]
  indicator_long_desc <- indicator_description[["descriptionKort"]]
  indicator_onsket_nivaa <- indicator_description[["MaalRetn"]]

  year <- dataframe_row[["Aar"]]
  indicator_value <- dataframe_row[["andel"]]
  number_of_ones <- dataframe_row[["value1"]]
  total <- dataframe_row[["total"]]

  indicator_value_n <- dataframe_row[["national_andel"]]
  number_of_ones_n <- dataframe_row[["national_value1"]]
  total_n <- dataframe_row[["national_total"]]

  if (indicator_onsket_nivaa == "lav") {
    indicator_onsket_nivaa <- "LAVT"
    icon_type <- function(indicator) {
      if (indicator < indicator_description$MaalNivaaGronn) {
        icon <- shiny::icon("fas fa-circle", class = "hoy")
      } else if (indicator > indicator_description$MaalNivaaGronn &
                indicator < indicator_description$MaalNivaaGul) {
        icon <- shiny::icon("fas fa-adjust", class = "moderal")
      } else {
        icon <- shiny::icon("circle-o", class = "lav")
      }
      return(icon)
    }
  } else  if (indicator_onsket_nivaa == "hoy") {
    indicator_onsket_nivaa <- "H\u00D8YT"
    icon_type <- function(indicator) {
      if (indicator > indicator_description$MaalNivaaGronn) {
        icon <- shiny::icon("fas fa-circle", class = "hoy")
      } else if (indicator < indicator_description$MaalNivaaGronn &
                 indicator > indicator_description$MaalNivaaGul) {
        icon <- shiny::icon("fas fa-adjust", class = "moderal")
      } else {
        icon <- shiny::icon("circle-o", class = "lav")
      }
      return(icon)
    }
  }

  tags$tr(
    tags$td(
      class = "kvalitetsindicator",
      tags$div(
        class = "register_navn",
        tags$h4(reg_name)),
      tags$div(
        class = "kvalitetsindicator_navn",
        tags$h1(indicator_title)
        ),
      tags$div(
        class = "qi_lang_description",
        tags$p(indicator_long_desc)),
      tags$div(
        class = "onsket_maalnivaa",
        tags$h4(paste0(
          "\u00D8NSKET M\U00C5LNIV\U00C5: ",
          indicator_onsket_nivaa)))
    ),
    tags$td(
      class = "valgt_enhet",
      tags$div(
        class = "aarstall",
        tags$p(year)
      ),
      tags$div(
        class = "nivaa",
        tags$h1(paste0(indicator_value, " %"),
                icon_type(indicator_value / 100))
      ),
      tags$div(
        class = "ones_of_total",
        tags$p(paste0(number_of_ones, " av ", total))
      )
    ),
    tags$td(
      class = "nasjonalt",
      tags$div(
        class = "aarstall",
        tags$p(year)
      ),
      tags$div(
        class = "nivaa",
        tags$div(
          class = "value",
          tags$h1(paste0(indicator_value_n, "%"),
                  icon_type(indicator_value_n / 100)))
      ),
      tags$div(
        class = "ones_of_total",
        tags$p(paste0(number_of_ones_n, " av ", total_n))
      )
    )
  )
}
