test_that("shiny table functions work", {
  ind_data <- qmongr::load_data() %>%
    qmongr::filter_data(
      filter_settings = list(Aar = 2017, ShNavn = "Trondheim, St. Olav")) %>%
    qmongr::aggregate_data() %>%
    qmongr::compute_indicator()
  national_data <- qmongr::load_data("indicator")[["indicator"]] %>%
    qmongr::compute_national_indicator()
  table_data <- ind_data %>%
    dplyr::inner_join(
      national_data,
      by = c(.data[["Aar"]],
             .data[["kvalIndID"]]))

  expect_type(
    qmongr::qi_table(table_data, "Trondheim, St. Olav"), "list")
  expect_equal(
    qmongr::qi_table(table_data, "Trondheim, St. Olav")$name, "table")
})
