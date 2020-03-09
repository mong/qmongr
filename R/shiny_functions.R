#' html table
#'
#' @param table_data a dataframe to construct the
#'   table from
#' @param selected_units the chosen unit
#' @param config the configuration setup
#'
#' @importFrom shiny tags
#' @export
#'

qi_table <- function(table_data, selected_units, config) {
  national <- table_data[["national"]]
  if (!rlang::is_empty(table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]])) {
    colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]])[
      colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]]) ==
        config[["data"]][["column"]][["unit_id"]][["rhf"]]] <- "OrgNr"
    colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]])[
      colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]]) ==
        config[["data"]][["column"]][["unit_name"]][["rhf"]]] <- "treatment_units"
  }
  if (!rlang::is_empty(table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]])) {
    colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]])[
      colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]]) ==
        config[["data"]][["column"]][["unit_id"]][["hf"]]] <- "OrgNr"
    colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]])[
      colnames(table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]])
      == "Hfkortnavn"] <- "treatment_units"
  }
  if (!rlang::is_empty(table_data$Sykehus)) {
    colnames(table_data$Sykehus)[
      colnames(table_data$Sykehus) == "SykehusId"] <- "OrgNr"
    colnames(table_data$Sykehus)[
      colnames(table_data$Sykehus) ==
        config[["data"]][["column"]][["unit_name"]][["sh"]]] <- "treatment_units"
  }
  table_data <- dplyr::bind_rows(
    table_data[["Sykehus"]],
    table_data[[config[["data"]][["column"]][["unit_name"]][["hf"]]]],
    table_data[[config[["data"]][["column"]][["unit_name"]][["rhf"]]]]
  )
  tags$table(
    tags$thead(
      tags$tr(
        tags$th(
          class = "quality_indicator",
          tags$h2(config$app_text$table$main_column)
        ),
        lapply(
          table_data$treatment_units %>% unique(),
          function(x) {
            shiny::tags$th(
              class = "selected_unit",
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
        config = config)
    )
  )
}

#'
#'constructs the body of a table
#'
#' @param datatable a row of a df
#' @param units selected treatment units
#' @param national a df with national indicator values
#' @param config the configuration setup
#'
#' @importFrom rlang .data
#' @importFrom shiny tags
#' @return a row of html table
#' @export
#'
table_body_constructor <- function(datatable, units, national, config) {
  indicator_description <- qmongr::load_data("description")[["description"]]
  reg_name <- indicator_description %>%
    dplyr::filter(.data[["IndID"]] %in%
      unique(datatable[[config$data$column$qi_id]])) %>%
    dplyr::select(.data[[config$data$column$source]]) %>%
    unique() %>%
    unlist() %>%
    stringr::str_sort(locale = config$language)
  names(reg_name) <- NULL

  #adds a table row tag with the register names and passes it to a function
  # that adds each quality indicator
  lapply(
    reg_name,
    function(rn) {
      indicator_name <- indicator_description %>%
        dplyr::filter(
          .data[[config$data$column$source]] == rn,
          .data[["IndID"]] %in% datatable[[config$data$column$qi_id]]) %>%
        dplyr::select(.data[["IndID"]]) %>%
        unique() %>%
        unlist() %>%
        stringr::str_sort(locale = config$language)
      names(indicator_name) <- NULL
      tagList(
        shiny::tags$tr(class = "register-row",
          shiny::tags$td(colspan = 7,
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

#' adds table rows with the values of quality indicators
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
        dplyr::filter(.data[["IndID"]] ==  indicator_name)
  reg_name <- indicator_description[["Register"]]
  indicator_title <- indicator_description[["IndTittel"]]
  indicator_long_desc <- indicator_description[["BeskrivelseKort"]]

  indicator_desired_level <- datatable %>%
    dplyr::filter(.data[[config$data$column$qi_id]] == indicator_name) %>%
    dplyr::select(.data[["desired_level"]]) %>%
    unique() %>%
    as.list.data.frame() %>%
    as.array()
  treatment_units <- datatable$treatment_units %>% unique()

  national <- national %>% dplyr::filter(
    .data[[config[["data"]][["column"]][["qi_id"]]]] == indicator_name)
  year <- national[[config[["data"]][["column"]][["year"]]]]
  total_n <- national[["count"]]
  level <- national[["level"]]
  if (national[[config[["data"]][["column"]][["qi_id"]]]] == "intensiv2") {
    indicator_value_n <- national[["indicator"]]
    number_of_ones_n <- ""
  } else {
    indicator_value_n <- paste0(round(
      national[["indicator"]] * 100
    ), "%")
    number_of_ones_n <- round(
      total_n * national[["indicator"]]
    )
  }
  return(
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
            config$app_text$table$desired_level, ": ",
            indicator_desired_level)))
      ),
      td <- lapply(
        treatment_units,
        qmongr::table_data,
        table_cell_data = datatable,
        indicator_name = indicator_name
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

#'insert values to a td tag
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
table_data <- function(units, table_cell_data, indicator_name) {
  config <- qmongr::get_config()
  table_cell_data <- table_cell_data %>%
    dplyr::filter(.data[["treatment_units"]] == units,
                  .data[[config$data$column$qi_id]] == indicator_name)

  if (nrow(table_cell_data) == 0) {
    return(
      tags$td(
        class = "selected_unit",
        ""
      )
    )
  } else {
  year <- table_cell_data[[config[["data"]][["column"]][["year"]]]]
  total <- table_cell_data[["count"]]
  level <- table_cell_data[["level"]]
  if (table_cell_data[[config$data$column$qi_id]] == "intensiv2") {
    indicator_value <- table_cell_data[["indicator"]]
    number_of_ones <- ""
  } else {
    indicator_value <- paste0(round(
      table_cell_data[["indicator"]] * 100
    ), "%")
    number_of_ones <- round(
      total * table_cell_data[["indicator"]]
    )
  }

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

#'adds an icon to the table cells with qi
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
