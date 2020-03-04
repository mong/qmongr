#' load data from qmongrdata
#'
#' @param data_type the dataframes to be loaded.
#'    It can be "description", "indicator", "hospital_name_structure"
#'    and "all".
#'
#' @return a list with dataframes
#' @export
#'
#' @examples
#' indicator_description <- load_data(data_type = "description")
#' indicator_data <- load_data(data_type = "indicator")
#' indicator_with_description <- load_data()
#'

load_data <- function(data_type = "all") {
  stopifnot(
    data_type %in%
      c("description", "indicator", "hospital_name_structure", "all"))
  invisible(
    switch(data_type,
      "description" = list(description = qmongrdata::IndBeskr),
      "indicator" = list(indicator = qmongrdata::KvalIndData),
      "hospital_name_structure" = list(
        hospital_name_structure = qmongrdata::SykehusNavnStruktur),
      "all" = list(
        description = qmongrdata::IndBeskr,
        indicator   = qmongrdata::KvalIndData,
        hospital_name_structure = qmongrdata::SykehusNavnStruktur
      )
    )
  )
}

#' adds HF or RHF organization nr
#'
#' @param data_list a list of dataframe
#' @param by can be RHF or HF
#'
#' @importFrom rlang .data
#' @return the input data with organization nr appended
#' @export
#'

add_orgnr <- function(data_list, by = "RHF") {
  config <- qmongr::get_config()
  org_column <- paste0("OrgNr", by)
  
    

    #adds the RHF or HF organization nr
    data_list[["indicator"]] <-  data_list[["indicator"]] %>%
      dplyr::left_join(
        data_list[["hospital_name_structure"]] %>%
          dplyr::select(
            .data[[org_column]],
            .data[["OrgNrShus"]],
            .data[["SykehusNavn"]]) %>%
          dplyr::mutate(
            "OrgNrShus" = as.character(.data[["OrgNrShus"]])),
        by = c( "OrgNrShus")
      ) %>%
      dplyr:: filter(!is.na(.data[["SykehusNavn"]]))
}

#' group data
#'
#' @inheritParams add_orgnr
#' @param by can be RHF, HF, hospital og an empty string
#'
#' @importFrom rlang .data
#'
#' @return aggregated data
#' @export
#'
group_data <- function(data_list, by) {
  config <- qmongr::get_config()
  if (by == "RHF" | by == "HF") {
    org_column <- paste0("OrgNr", by)
    data_list[["indicator"]] <- add_orgnr(data_list, by) %>%
      dplyr::group_by(
        .data[[org_column]],
        .data[["Aar"]],
        .data[[config$data$column$qi_id]]
     )
  } else if (by == "hospital") {
    data_list[["indicator"]] <- data_list[["indicator"]] %>%
      dplyr::group_by(
        .data[[config$data$column$unit_id$sh]],
        .data[["Aar"]],
        .data[[config$data$column$qi_id]]
      )
  } else if (by == "") {
    data_list[["indicator"]] <- data_list[["indicator"]] %>%
      dplyr::group_by(
        .data[["Aar"]],
        .data[[config$data$column$qi_id]]
      )
  }
  #
  indicator_median <- "intensiv2"
  indicator_mean <- c(
    "nakke1", "nakke2", "nakke3", "nakke4", "intensiv1"
  )
  grouped_mean <- data_list[["indicator"]] %>%
    dplyr::filter(.data[[config$data$column$qi_id]] %in% indicator_mean) %>%
    compute_indicator_mean()

  grouped_median <- data_list[["indicator"]] %>%
    dplyr::filter(.data[[config$data$column$qi_id]] %in% indicator_median) %>%
    compute_indicator_median()
  grouped <- dplyr::bind_rows(grouped_mean, grouped_median) %>%
    dplyr::arrange(.data[[config$data$column$qi_id]]) %>%
    dplyr::ungroup() %>%
    as.data.frame()
  levels_added <- get_indicator_level(
    grouped_data = grouped,
    description = data_list[["description"]]
  )
}

#' calculates  mean value of the grouped variabels
#'
#' @param grouped_data aggregated data
#'
#' @importFrom rlang .data
#'
#' @return aggrgated data with indicators
#' @export

compute_indicator_mean <- function(grouped_data)  {
  grouped_data %>%
    dplyr::summarise(
      count = dplyr::n(),
      indicator = mean(Variabel)
    )
}
#' calculates median (portion in % )
#'
#' @param agg_data aggregated data
#'
#' @importFrom rlang .data
#'
#' @return aggrgated data with indicators
#' @export

compute_indicator_median <- function(grouped_data)  {
  grouped_data %>%
    dplyr::summarise(
      count = dplyr::n(),
      indicator = median(Variabel)
    )
}

#' Adds a column with inidcator levels and
#' and another with desired levels to the grouped data
#' 
#' @param grouped_data a dataframe
#' @param description a
#'
#' @importFrom rlang .data
#' @return the input data with ad
#' ditional indicator level
#'  and desired level columns
#' @export
#'
get_indicator_level <- function(grouped_data, description) {
  config <- qmongr::get_config()
  grouped_data$level <- ""
  grouped_data$desired_level <- ""
  high <- function(indicator, green, yellow) {
    if (indicator > green) {
      level <- "H"
    } else if (indicator < green & indicator > yellow) {
      level <- "M"
    } else {
      level <- "L"
    }
    desired_level <-  "H\u00F8yt"
    return(list(level = level, desired_level = desired_level))
  }
  low <- function(indicator, green, yellow) {
    if (indicator < green) {
      level <- "H"
    } else if (indicator > green & indicator < yellow) {
      level <- "M"
    } else {
      level <- "L"
    }
    desired_level <-  "Lavt"
    return(list(level = level, desired_level = desired_level))
  }
  lapply(
    seq_len(nrow(grouped_data)),
    function(x) {
      data_row <- grouped_data[x, ]
      description <- description %>%
        dplyr::filter(.data[["IndID"]] == data_row[[config$data$column$qi_id]])
      if (!is.na(description[["MaalRetn"]])) {
        if (!is.na(description[["MaalNivaaGronn"]]) &
            !is.na(description[["MaalNivaaGul"]])) {
          if (description[["MaalRetn"]] == 1) {
            level <- high(
              indicator = data_row[["indicator"]],
              green = description[["MaalNivaaGronn"]],
              yellow = description[["MaalNivaaGul"]]
            )
          } else if (description[["MaalRetn"]] == 0) {
            level <- low(
              indicator = data_row[["indicator"]],
              green = description[["MaalNivaaGronn"]],
              yellow =  description[["MaalNivaaGul"]]
            )
          }
        } else {
          desired_level <- switch(
            paste(description[["MaalRetn"]]),
            "1" =  "H\u00F8yt",
            "0" =  "Lavt"
          )
          level <- list(level = "undefined", desired_level = desired_level)
        }
      } else{
        level <- list(level = "undefined", desired_level = "undefined")
      }
      grouped_data$level[x] <<- level$level
      grouped_data$desired_level[x] <<- level$desired_level
    }
  )
  return(grouped_data)
}
