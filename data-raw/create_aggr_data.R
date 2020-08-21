# Create app_data beforehand, to speed up app.

config <- qmongr::get_config()
aggr_data <- qmongrdata:::app_data(config)
usethis::use_data(aggr_data, overwrite = TRUE)


## Renamed columns Aug. 21 2020

aggr_data <- qmongr::aggr_data
aggr_data$register_data$description <- aggr_data$register_data$description
aggr_data$register_data$description <- aggr_data$register_data$description %>% dplyr::rename(id = IndID)
aggr_data$register_data$description <- aggr_data$register_data$description %>% dplyr::rename(registry_id = Register, title = IndTittel, name = IndNavn, level_green = MaalNivaaGronn, level_yellow = MaalNivaaGul)
aggr_data$register_data$description <- aggr_data$register_data$description %>% dplyr::rename(short_description = BeskrivelseKort, long_description = BeskrivelseLang)
aggr_data$register_data$description <- aggr_data$register_data$description %>% dplyr::rename(level_direction = MaalRetn)
aggr_data$grouped_by_hospital <- aggr_data$grouped_by_hospital %>% dplyr::rename(year = Aar, ind_id = KvalIndID, denominator = count, unit_name = SykehusNavn, orgnr = OrgNrShus, var = indicator)
aggr_data$grouped_by_hf <- aggr_data$grouped_by_hf %>% dplyr::rename(year = Aar, ind_id = KvalIndID, denominator = count, unit_name = Hfkortnavn, orgnr = OrgNrHF, var = indicator)
aggr_data$grouped_by_rhf <- aggr_data$grouped_by_rhf %>% dplyr::rename(year = Aar, ind_id = KvalIndID, denominator = count, unit_name = RHF, orgnr = OrgNrRHF, var = indicator)
aggr_data$national_data <- aggr_data$national_data %>% dplyr::rename(year = Aar, ind_id = KvalIndID, denominator = count, var = indicator)

aggr_data$national_data$unit_name <- "Nasjonalt"


aggr_data$register_data$description$full_name <- "Norsk bløtskaderegister"

usethis::use_data(aggr_data, overwrite = TRUE)


