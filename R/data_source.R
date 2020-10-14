#' Provide data for qmongr
#'
#' Provide data sets used by qmongr. Currently based on context (env vars)
#'
#' @return List of data sets
#' @name data_source
#' @importFrom rlang .data
#' @aliases get_data
NULL

#' @rdname data_source
#' @export
get_data <- function() {

  if (Sys.getenv("IMONGR_CONTEXT") == "DEV" |
      grepl("node", Sys.getenv("NODE_NAME"))) {
    # nocov start ,  testing in imongr
    conf <- get_config()
    pool <- imongr::make_pool()
    on.exit(imongr::drain_pool(pool))
    description <- imongr::get_table(pool, "ind")
    registry <- imongr::get_table(pool, "registry")

    registry <- dplyr::rename(
      registry,
      rname = name,
      registry_id = id
    )
    description <- description %>%
      dplyr::inner_join(registry, by = conf$column$registry_id)
    df <- imongr::get_table(pool, "agg_data")

    # filter
    ## include
    include <- dplyr::select(description, .data$id, .data$include)
    df <- df %>%
      dplyr::left_join(include, by = c("ind_id" = "id"))
    df <- df %>%
      dplyr::filter(.data$include == 1)
    ## coverage
    if (conf$filter$coverage$use) {
      print("Filter by coverage")
      df <- df %>%
        dplyr::filter(!is.na(.data$dg))
      df <- df %>%
        dplyr::filter(.data$dg >= conf$filter$coverage$level)
    }
    ## filter if N < 5
    if (conf$filter$denominator$use) {
      df <- df[df[[conf$column$denominator]] > conf$filter$denominator$level, ]
    }

    ## age
    if (conf$filter$age$use) {
      year_end <- as.numeric(format(Sys.Date(), "%Y")) - conf$filter$age$years
      selectable_treatment_units <- df %>%
        dplyr::filter(year >= year_end) %>%
        dplyr::select(conf$column$treatment_unit) %>%
        dplyr::distinct() %>%
        dplyr::pull()
      df <- df[df[[conf$column$treatment_unit]] %in% selectable_treatment_units, ]
    }

    # split unit levels and continue renaming
    grouped_by_hospital <- df[df$unit_level == "hospital", ]
    grouped_by_hf <- df[df$unit_level == "hf", ]
    grouped_by_rhf <- df[df$unit_level == "rhf", ]
    national_data <- df[df$unit_level == "nation", ]

    list(register_data = list(description = description),
         grouped_by_hospital = grouped_by_hospital,
         grouped_by_hf = grouped_by_hf,
         grouped_by_rhf = grouped_by_rhf,
         national_data = national_data)
    # nocov end
  } else {
    qmongr::aggr_data
  }
}
