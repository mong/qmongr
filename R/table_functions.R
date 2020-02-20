#' load data
#'
#' @param data_type the dataframe to be loaded.
#'    It can be "description", "indicator" or "both".
#'
#' @return a list with dataframes
#' @export
#'
#' @examples
#' indicator_description <- load_data(data_type = "description")
#' indicator_data <- load_data(data_type = "indicator")
#' indicator_with_description <- load_data()
#'

load_data <- function(data_type = "both") {
  stopifnot(data_type %in% c("description", "indicator", "both"))
  invisible(
    switch(data_type,
      "description" = list(description = qmongrdata::IndBeskrNakke),
      "indicator" = list(indicator = qmongrdata::KvalIndData),
      "both" = list(
        description = qmongrdata::IndBeskrNakke,
        indicator   = qmongrdata::KvalIndData
      )
    )
  )
}

#' filter data
#' @param data_list a list of dataframes
#' @param filter_settings list of values that will be used to subset the
#'   dataframe. The list elements should have the same name as the columns
#'   in the dataframe.
#' @importFrom rlang .data
#' @return list of filtered dataframes
#' @export
#'
#'
#'

filter_data <- function(data_list, filter_settings = NULL) {

  if (is.null(filter_settings)) {
    return(data_list)
  } else {
    if (!is.null(filter_settings[["kvalIndID"]])) {
      filter_settings[["kvalIndID"]] <- data_list[["description"]] %>%
        dplyr::filter(.data[["Register"]] == filter_settings[["kvalIndID"]]) %>%
        dplyr::select(.data[["indID"]]) %>%
        unique()
    }
    length_of_filter <-  length(names(filter_settings))

    for (i in seq_len(length_of_filter)) {
      data_list[["indicator"]] <-  data_list[["indicator"]] %>%
        dplyr::filter(
          .data[[names(filter_settings)[[i]]]] %in%
          filter_settings[[names(filter_settings)[[i]]]]
      )
    }
    return(data_list)
  }
}

#' aggregate data
#'
#' @inheritParams filter_data
#'
#' @importFrom rlang .data
#'
#' @return aggregated data
#' @export
#'

aggregate_data <- function(data_list) {
 agg_data <-  data_list[["indicator"]] %>%
    dplyr::group_by(
      .data[["ShNavn"]],
      .data[["Aar"]],
      .data[["Variabel"]],
      .data[["kvalIndID"]])  %>%
    dplyr::summarise(count = dplyr::n()) %>%
    tidyr::pivot_wider(
      names_from = .data[["Variabel"]],
      names_prefix = "value",
      values_from = .data[["count"]],
      values_fill = list(count = 0))
}

#'
#' calculates ki (portion in % )
#'
#' @param agg_data aggregated data
#'
#' @importFrom rlang .data
#'
#' @return aggrgated data with indicators
#' @export

compute_indicator <- function(agg_data)  {

  if (!"value1" %in% names(agg_data)) {
    agg_data[["value1"]] <- 0
  }
  agg_data %>%
    dplyr::mutate(
      total = .data[["value0"]] + .data[["value1"]],
      andel = round(.data[["value1"]] * 100 / .data[["total"]]))
}

#'calculates the values of national KI
#'
#' @param qi_data a dataframe
#'
#' @importFrom rlang .data
#'
#' @return dataframe with the the values of national ki
#' @export
#'
#'
compute_national_indicator <- function(qi_data) {
  qi_data  %>%
    dplyr::group_by(
      .data[["Aar"]],
      .data[["kvalIndID"]],
      .data[["Variabel"]]) %>%
    dplyr::summarise(count = dplyr::n()) %>%
    tidyr::pivot_wider(names_from = .data[["Variabel"]],
                       names_prefix = "national_value",
                       values_from = .data[["count"]],
                       values_fill = list(count = 0)) %>%
    dplyr::mutate(
      national_total =
        .data[["national_value0"]] + .data[["national_value1"]],
      national_andel =
        round(.data[["national_value1"]] * 100 / .data[["national_total"]])
    )
}
