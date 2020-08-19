#' Provide data for qmongr
#'
#' Provide data sets used by qmongr. Currently based on context (env vars)
#'
#' @return List of data sets
#' @name data_source
#' @aliases agg_data
NULL

#' @rdname data_source
#' @export
agg_data <- function() {

  if (Sys.getenv("IMONGR_CONTEXT") == "DEV" |
      grepl("node", Sys.getenv("NODE_NAME"))) {
    # nocov start ,  testing in imongr
    conf <- get_config()
    pool <- imongr::make_pool()
    on.exit(imongr::drain_pool(pool))
    description <- imongr::get_indicator(pool)
    df <- imongr::get_agg_data(pool)
    # some vars need to be translated
    # should be avoided when agreemnt upon consistent data model...
    names(df)[names(df) == "ind_id"] <- conf$data$column$qi_id
    names(df)[names(df) == "year"] <- conf$data$column$year
    names(df)[names(df) == "var"] <- "indicator"
    # split unit levels and continue renaming
    grouped_by_hospital <- df[df$unit_level == "hospital", ]
    names(grouped_by_hospital)[names(grouped_by_hospital) == "orgnr"] <-
      "OrgNrShus"
    names(grouped_by_hospital)[names(grouped_by_hospital) == "unit_name"] <-
      "SykehusNavn"
    grouped_by_hf <- df[df$unit_level == "hf", ]
    names(grouped_by_hf)[names(grouped_by_hf) == "orgnr"] <- "OrgNrHF"
    names(grouped_by_hf)[names(grouped_by_hf) == "unit_name"] <- "Hfkortnavn"
    grouped_by_rhf <- df[df$unit_level == "rhf", ]
    names(grouped_by_rhf)[names(grouped_by_rhf) == "orgnr"] <- "OrgNrRHF"
    names(grouped_by_rhf)[names(grouped_by_rhf) == "unit_name"] <- "RHF"
    national_data <- df[df$unit_level == "national", ]

    # imongr::get_registry_name() may be ext towards handling vector args...
    rid <- description$registry_id
    rname <- vector()
    for (i in seq_len(length(rid))) {
      rname <- c(rname, imongr::get_registry_name(pool, rid[i]))
    }

    description <- description %>%
      tibble::tibble() %>%
      dplyr::rename(IndID = id, IndTittel = title, IndNavn = name,
                    MaalNivaaGronn = level_green, MaalNivaaGul = level_yellow,
                    MaalRetn = level_direction,
                    BeskrivelseKort = short_description,
                    BeskrivelseLang = long_description) %>%
      dplyr::mutate(Register = rname)

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
