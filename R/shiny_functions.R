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
          class = "quality_indicator",
          tags$h2("Kvalitetsindikator")
        ),
        tags$th(
          class = "selected_unit",
          tags$h2(enhet)
        ),
        tags$th(
          class = "nationally",
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
  indicator_long_desc <- indicator_description[["BeskrivelseKort"]]
  indicator_desired_level <- indicator_description[["MaalRetn"]]

  year <- dataframe_row[["Aar"]]
  indicator_value <- dataframe_row[["andel"]]
  number_of_ones <- dataframe_row[["value1"]]
  total <- dataframe_row[["total"]]

  indicator_value_n <- dataframe_row[["national_andel"]]
  number_of_ones_n <- dataframe_row[["national_value1"]]
  total_n <- dataframe_row[["national_total"]]

  if (indicator_desired_level == "lav") {
    indicator_desired_level <- "LAVT"
    icon_type <- function(indicator) {
      if (indicator < indicator_description$MaalNivaaGronn) {
        icon <- shiny::icon("fas fa-circle", class = "high")
      } else if (indicator > indicator_description$MaalNivaaGronn &
                indicator < indicator_description$MaalNivaaGul) {
        icon <- shiny::icon("fas fa-adjust", class = "moderate")
      } else {
        icon <- shiny::icon("circle-o", class = "low")
      }
      return(icon)
    }
  } else  if (indicator_desired_level == "hoy") {
    indicator_desired_level <- "H\u00D8YT"
    icon_type <- function(indicator) {
      if (indicator > indicator_description$MaalNivaaGronn) {
        icon <- shiny::icon("fas fa-circle", class = "high")
      } else if (indicator < indicator_description$MaalNivaaGronn &
                 indicator > indicator_description$MaalNivaaGul) {
        icon <- shiny::icon("fas fa-adjust", class = "moderate")
      } else {
        icon <- shiny::icon("circle-o", class = "low")
      }
      return(icon)
    }
  }

  tags$tr(
    tags$td(
      class = "quality_indicator",
      tags$div(
        class = "register_name",
        tags$h4(reg_name)),
      tags$div(
        class = "quality_indicator_name",
        tags$h1(indicator_title)
        ),
      tags$div(
        class = "qi_long_description",
        tags$p(indicator_long_desc)),
      tags$div(
        class = "desired_target_level",
        tags$h4(paste0(
          "\u00D8NSKET M\U00C5LNIV\U00C5: ",
          indicator_desired_level)))
    ),
    tags$td(
      class = "selected_unit",
      tags$div(
        class = "year",
        tags$p(year)
      ),
      tags$div(
        class = "level",
        tags$h1(paste0(indicator_value, " %"),
                icon_type(indicator_value / 100))
      ),
      tags$div(
        class = "ones_of_total",
        tags$p(paste0(number_of_ones, " av ", total))
      )
    ),
    tags$td(
      class = "nationally",
      tags$div(
        class = "year",
        tags$p(year)
      ),
      tags$div(
        class = "level",
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
