# Fagområde
fagomr <- yaml::read_yaml("data-raw/fag.yml")
usethis::use_data(fagomr, overwrite = TRUE)
