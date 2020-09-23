#' Provide data for qmongr
#'
#' Provide data sets used by qmongr. Currently based on context (env vars)
#'
#' @return List of data sets
#' @name data_source
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
    description <- imongr::get_indicator(pool)
    registry <- imongr::get_registry(pool)

    registry <- dplyr::rename(
      registry,
      rname = name,
      registry_id = id
    )
    description <- description %>% dplyr::inner_join(registry, by = conf$column$registry_id)
    df <- imongr::get_agg_data(pool)
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
