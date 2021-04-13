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
    # Keep include == 1 and type == "andel"
    # qmongjs is not able to show other types than "andel"
    include <- dplyr::select(description, .data$id, .data$include, .data$type)
    df <- df %>%
      dplyr::left_join(include, by = c("ind_id" = "id"))
    df <- df %>%
      dplyr::filter(.data$include == 1) %>%
      dplyr::filter(.data$type == "andel")
    ## coverage
    if (conf$filter$coverage$use) {
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

    hospital <-  grouped_by_hospital[[conf$column$treatment_unit]] %>%
      unique()
    ## tu names in one table
    tu_names <-  data.frame(hospital = hospital) %>%
      dplyr::left_join(
        imongr::get_table(pool, "hospital") %>%
        dplyr::select(
          conf$column$tu_name_short,
          conf$column$orgnr_local,
          conf$column$orgnr_hf
        ),
        by = c(hospital = conf$column$tu_name_short)
      ) %>%
      dplyr::left_join(
        imongr::get_table(pool, "hf") %>%
          dplyr::select(
            conf$column$tu_name_short,
            conf$column$tu_name_full,
            conf$column$orgnr_local,
            conf$column$orgnr_rhf
          ),
        by = c(hf_orgnr = conf$column$orgnr_local)
      ) %>%
      dplyr::rename(hf = short_name, hf_full = full_name) %>%
      dplyr::left_join(
        imongr::get_table(pool, "rhf") %>%
          dplyr::select(
            conf$column$tu_name_short,
            conf$column$tu_name_full,
            conf$column$orgnr_local
          ),
        by = c(rhf_orgnr = conf$column$orgnr_local)
      ) %>%
      dplyr::rename(rhf = short_name, rhf_full = full_name) %>%
      dplyr::select(
        hospital, hf, hf_full, rhf
      ) %>%
      dplyr::distinct()

    list(register_data = list(description = description),
         grouped_by_hospital = grouped_by_hospital,
         grouped_by_hf = grouped_by_hf,
         grouped_by_rhf = grouped_by_rhf,
         national_data = national_data,
         tu_names = tu_names)
    # nocov end
  } else {
    qmongr::aggr_data
  }
}
