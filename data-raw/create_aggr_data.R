# Create app_data beforehand, to speed up app.

config <- qmongr::get_config()
aggr_data <- qmongrdata:::app_data(config)
usethis::use_data(aggr_data, overwrite = TRUE)
