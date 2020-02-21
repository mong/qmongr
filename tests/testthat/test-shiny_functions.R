test_that("qi_table", {
  ind_data <- readRDS("data/compute_indicator2.rds")
  national_data <- readRDS("data/compute_national_indicator1.rds")

  table_data <- ind_data %>%
    dplyr::inner_join(
      national_data,
      by = c(.data[["Aar"]],
             .data[["kvalIndID"]]))

  expect_error(qmongr::qi_table(table_data))
  expect_equal_to_reference(qmongr::qi_table(table_data, "Trondheim, St. Olav"), "data/qi_table1.rds")
})
