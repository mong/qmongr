#' html table
#'
#' @param table_data a dataframe to construct the
#'   table from
#' @param selected_units the chosen unit
#' @param config the configuration setup
#' @param indicator_description indicator description
#'
#' @importFrom shiny tags
#' @export
#'

qi_table <- function(table_data, selected_units, indicator_description, config) {

  national <- table_data[["national"]]
  table_data <- dplyr::bind_rows(
    table_data[[config$treatment_unit_level$hospital]],
    table_data[[config$treatment_unit_level$hf]],
    table_data[[config$treatment_unit_level$rhf]]
  )

  nr_treatment_units <- table_data[[config$column$treatment_unit]] %>% unique() %>% length()
  col_width <- floor(60 / (nr_treatment_units + 1))
  tags$table(
    tags$thead(
      tags$tr(
        tags$th(
          class = "quality_indicator",
          style = paste0("width: 40%;"),
          tags$h2(config$app_text$table$main_column)
        ),
        lapply(
          table_data[[config$column$treatment_unit]] %>% unique(),
          function(x) {
            shiny::tags$th(
              class = "selected_unit",
              style = paste0("width:", col_width, "%;"),
              tags$h2(x)
            )
          }
        ),
        tags$th(
          class = "nationally",
          tags$h2(config$app_text$table$national_column)
        ),
      )
    ),
    tags$tbody(
      qmongr::table_body_constructor(
        datatable = table_data,
        units = selected_units,
        national = national,
        indicator_description = indicator_description,
        config = config)
    )
  )

}

#' Construct table body
#'
#' Constructs the body of a table, used by qi_table
#' @seealso \code{\link{qi_table}}
#'
#' @param datatable a row of a df
#' @param units selected treatment units
#' @param national a df with national indicator values
#' @param config the configuration setup
#' @param indicator_description indicator description
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return a row of html table
#' @export
#'
table_body_constructor <- function(datatable, units, national, indicator_description, config) {

  reg_name <- indicator_description %>%
    dplyr::filter(.data[[config$column$id]] %in%
      unique(datatable[[config$column$indicator_id]])) %>%
    dplyr::select(.data[[config$column$registry_full_name]]) %>%
    unique() %>%
    unlist() %>%
    stringr::str_sort(locale = config$language)
  names(reg_name) <- NULL
  col_nr <-  datatable[[config$column$treatment_unit]] %>% unique() %>% length() + 2

  #adds a table row tag with the register names and passes it to a function
  # that adds each quality indicator
  lapply(
    reg_name,
    function(rn) {
      indicator_name <- indicator_description %>%
        dplyr::filter(
          .data[[config$column$registry_full_name]] == rn,
          .data[[config$column$id]] %in% datatable[[config$column$indicator_id]]) %>%
        dplyr::select(.data[[config$column$id]]) %>%
        unique() %>%
        unlist() %>%
        stringr::str_sort(locale = config$language)
      names(indicator_name) <- NULL
      tagList(
        shiny::tags$tr(class = "register-row",
          shiny::tags$td(colspan = col_nr,
                         shiny::tags$h4(rn)
          )
        ),
        lapply(
          indicator_name,
          qmongr::indicator_rows,
          indicator_description = indicator_description,
          config = config,
          datatable = datatable,
          units = units,
          national = national
        )
      )
    }
  )
}

#' Add quality indicators to table
#'
#' Adds table rows with the values of quality indicators
#' @inheritParams table_body_constructor
#' @param indicator_name names of the input qi
#' @param indicator_description indicator description
#' @param config the configuration setup
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#'
#' @export
#'
indicator_rows <- function(indicator_name, indicator_description, config, datatable, units, national) {

  indicator_description <- indicator_description %>%
        dplyr::filter(.data[[config$column$id]] ==  indicator_name)

  indicator_title <- indicator_description[[config$column$indicator_title]]
  indicator_long_desc <- indicator_description[[config$column$indicator_short_description]]

  indicator_desired_level <- datatable %>%
    dplyr::filter(.data[[config$column$indicator_id]] == indicator_name) %>%
    dplyr::select(.data[[config$column$level_direction]]) %>%
    unique()

  if (indicator_desired_level == 1) {
    indicator_desired_level <-  config$desired_level$high
  } else if (indicator_desired_level == 0) {
    indicator_desired_level <- config$desired_level$low
  }

  treatment_units <- datatable[[config$column$treatment_unit]] %>% unique()

  national <- national %>% dplyr::filter(
    .data[[config$column$indicator_id]] == indicator_name)
  year <- national[[config$column$year]]
  total_n <- national[[config$column$denominator]]
  level <- national[[config$column$achieved_level]]
  indicator_value_n <- paste0(round(
    national[[config$column$variable]] * 100
  ), "%")
  number_of_ones_n <- round(
    total_n * national[[config$column$variable]]
  )
  return(
    tags$tr(
      id = indicator_name,
      class = "indicator",
      tags$td(
        class = "quality_indicator",
        style = "width: 40%;",
        ## tags$div(
        ##   class = "register_name",
        ##   tags$h4(reg_name)),
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
            config$app_text$table$desired_level, ": ",
            indicator_desired_level)))
      ),
      td <- lapply(
        treatment_units,
        qmongr::table_data,
        table_cell_data = datatable,
        indicator_name = indicator_name,
        config = config
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
          tags$h3(paste0(indicator_value_n),
                  icon_type(level)))
        ),
        tags$div(
          class = "ones_of_total",
          tags$p(paste0(number_of_ones_n, " av ", total_n))
        )
      )
    )
  )
}

#' Insert values in table
#'
#'Insert values to a td tag
#'
#' @inheritParams indicator_rows
#' @param table_cell_data table cell data
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @importFrom magrittr "%<>%"
#' @return the contnets of a td tag
#' @export
#'
table_data <- function(units, table_cell_data, indicator_name, config) {

  table_cell_data <- table_cell_data %>%
    dplyr::filter(
      .data[[config$column$treatment_unit]] == units,
      .data[[config$column$indicator_id]] == indicator_name
    )

  if (nrow(table_cell_data) == 0) {
    return(
      tags$td(
        class = "selected_unit",
        ""
      )
    )
  } else {
  year <- table_cell_data[[config$column$year]]
  total <- table_cell_data[[config$column$denominator]]
  level <- table_cell_data[[config$column$achieved_level]]
  indicator_value <- paste0(round(
    table_cell_data[[config$column$variable]] * 100
  ), "%")
  number_of_ones <- round(
    total * table_cell_data[[config$column$variable]]
  )

    return(
      shiny::tags$td(class = "selected_unit",
        tags$div(
          class = "year",
          tags$p(year)
        ),
        tags$div(
          class = "level",
          tags$h3(paste0(indicator_value),
                  icon_type(level)
          )
        ),
        tags$div(
          class = "ones_of_total",
          tags$p(paste0(number_of_ones, " av ", total))
        )
      )
    )
  }
}

#' Add icon
#'
#' Adds an icon to the table cells with quality indicators
#'
#' @param level the indicator level
#'
#' @export
#'

icon_type <- function(level) {
 icon <-  switch(
    level,
    "H" = shiny::icon("fas fa-circle", class = "high"),
    "M" =  shiny::icon("fas fa-adjust", class = "moderate"),
    "L" = shiny::icon("circle-o", class = "low"),
    "ikke definert" = NULL
  )
  return(icon)
}
