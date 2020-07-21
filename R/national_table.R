# html table
#'
#' @title national values in indicator table
#'
#' @description html table that displays the national values
#'  in the indicator rows. The table is shown when a treatment
#'   unit is not selected
#'
#' @param input_data a dataframe to construct the
#'   table from
#' @param indicator_description the indicator description file
#' @param config the configuration setup
#'
#' @importFrom shiny tags
#' @importFrom rlang .data
#' @export
#'

national_table <- function(input_data, indicator_description, config) {

  tags$table(
    tags$thead(
      tags$tr(
        tags$th(
          class = "quality_indicator",
          style = "width: 60%;",
          tags$h2(config$app_text$table$main_column)
        ),
        tags$th(
          class = "nationally",
          style = "width:40%",
          tags$h2(config$app_text$table$national_column)
        ),
      )
    ),
    tags$tbody(
      tbody_content(input_data, indicator_description, config)
    )
  )
}
#'
#'constructs the body of a table
#'
#' @inheritParams national_table
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return tbody of the html table
#' @export
#'
tbody_content <- function(input_data, indicator_description, config) {
  indicator_col_id <- config$data$column$qi_id
  register_col_id <- config$data$column$source
  register_name <- indicator_description %>%
    dplyr::filter(
      .data[["IndID"]] %in%
        unique(input_data[[indicator_col_id]])
    ) %>%
    purrr::pluck(register_col_id) %>%
    unique() %>%
    stringr::str_sort(locale = config$language)

  lapply(
    register_name,
    function(reg_name) {
      indicator_description <- indicator_description %>%
        dplyr::filter(.data[[register_col_id]] == reg_name)
      indicators_in_reg <- indicator_description %>%
        purrr::pluck("IndID") %>%
        unique()
      input_data <- input_data %>%
        dplyr::filter(.data[[indicator_col_id]] %in% indicators_in_reg)

      shiny::tagList(
        register_tr(
          register_name = reg_name,
          col_span = 2
        ),
        national_register_content(
          input_data = input_data,
          indicator_description = indicator_description,
          config = config
        )
      )
    }
  )
}


#'
#'constructs the body of a table
#'
#' @inheritParams national_table
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return tbody of the html table
#' @export
#'
national_register_content <- function(input_data, indicator_description, config) {
  indicator_col_id <- config$data$column$qi_id
  indicator_name <- input_data %>%
    purrr::pluck(indicator_col_id) %>%
    unique()

  lapply(
    indicator_name,
    function(indicator_name) {
      indicator_description <- indicator_description %>%
        dplyr::filter(.data[["IndID"]] == indicator_name)

      input_data <- input_data %>%
        dplyr::filter(.data[[indicator_col_id]] == indicator_name)
      table_d <- nattional_indicator_content(
        input_data = input_data,
        indicator_description = indicator_description,
        config = config
      )
      tags$tr(
        id = indicator_name,
        class = "indicator",
        table_d
      )
    }
  )
}

#'
#'constructs the body of a table
#'
#' @inheritParams national_table
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return tbody of the html table
#' @export
#'

nattional_indicator_content <- function(input_data, indicator_description, config) {

  return(
    shiny::tagList(
      description_td(
        description_row = indicator_description,
        desired_level_text = config$app_text$indicators$high),
      indicator_value_td(
        td_data = input_data,
        col_name_indicator_id = config$data$column$qi_id,
        class_name = "nationally"
      )
    )
  )
}

# html td
#'
#' @title adds table tags around register name
#'
#' @description A function that adds tr and td tags to the register
#' name with col_span.
#'
#' @param register_name name of the register
#' @param col_span the total number of columns in the table
#'
#' @return a register name with tr and td tags including colSpan
#' @importFrom shiny tags
#' @export
#'

register_tr <- function(register_name, col_span) {
  return(
    tags$tr(
      class = "register-row",
      shiny::tags$td(
        colspan = col_span,
        shiny::tags$h4(register_name)
      )
    )
  )
}

# generates the desctiption of indcators in the table
#'
#' @title td tag with indicator description
#'
#' @description html table that displays the national values
#'  in the indicator rows. The table is shown when a treatment
#'   unit is not selected
#'
#' @param description_row a single row from the description table which
#' includes the indicator id, indicator title and a short description
#' of the indicator and the desired indicator values
#' @param desired_level_text text from config about the desired level
#' @return to td tag with three div, the first with the indicator title,
#' the second has the description and the last surround the desired levels
#'
#' @importFrom shiny tags
#' @export
#'

description_td <- function(description_row, desired_level_text) {
  #config$app_text$table$desired_level
  if (description_row["MaalRetn"] == 0) {
    direction <-  "< "
  } else if (description_row["MaalRetn"] == 1) {
    direction <-   "> "
  }
  green_value <- paste0(description_row["MaalNivaaGronn"] * 100, "%")
  indicator_desired_level <- paste(
    desired_level_text, ": ",
    direction, green_value, sep = ""
  )
  indicator_long_desc <- description_row["BeskrivelseKort"]
  indicator_title <- description_row["IndTittel"]

  return(
    tags$td(
      class = "quality_indicator",
      style = "width: 40%;",
      tags$div(
        class = "quality_indicator_name",
        tags$h1(indicator_title)
      ),
      tags$div(
        class = "qi_long_description",
        tags$p(indicator_long_desc)),
      tags$div(
        class = "desired_target_level",
        tags$h4(indicator_desired_level)
      )
    )
  )
}

# html td
#'
#' @title  adds td tag around indicator values
#'
#' @description adds a td tag around the indcator values, level and
#'  N of a selected unit and national values
#'
#' @param td_data a row of indicator data from the dataframe that
#'  corresponds to the selected unit
#' @param col_name_indicator_id column name of the indicator column
#'  from config
#' @param class_name class name of the td. can be "selected_unit" or "National"
#'
#' @return td with two divs. The first includes the indicator value
#'  and corresponding icon and the second the number of individuals
#'  that make up the numbers.
#'
#' @importFrom shiny tags
#' @export
#'

indicator_value_td <- function(td_data, col_name_indicator_id, class_name = "National") {
  if (nrow(td_data) == 0) {
    return(
      tags$td(
        class = class_name,
        ""
      )
    )
  } else {
    total <- td_data[["count"]]
    level <- td_data[["level"]]
    if (td_data[col_name_indicator_id] == "intensiv2") {
      indicator_value <- td_data[["indicator"]]
      number_of_ones <- ""
    } else {
      indicator_value <- paste0(round(
        td_data[["indicator"]] * 100
      ), "%")
      number_of_ones <- round(
        total * td_data[["indicator"]]
      )
    }

    return(
      shiny::tags$td(
        class = class_name,
        tags$div(
          class = "level",
          tags$div(
            class = "value",
            style = "display:flex;justify-content:center;",
            tags$h3(
              paste0(indicator_value),
              icon_type(level)
            )
          )
        ),
        tags$div(
          class = "ones_of_total",
          style = "display:flex;justify-content:center;",
          tags$p(paste0(number_of_ones, " av ", total))
        )
      )
    )
  }
}
