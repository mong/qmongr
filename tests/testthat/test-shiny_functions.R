test_that("qi_table", {
  ind_data <- readRDS("data/compute_indicator2.rds")
  national_data <- readRDS("data/compute_national_indicator1.rds")
  config <- get_config()

  table_data <- ind_data %>%
    dplyr::inner_join(
      national_data,
      by = c(.data[["Aar"]],
             .data[["KvalIndID"]]))

  expect_error(qi_table(table_data))
  expect_equal(qi_table(table_data, "Trondheim, St. Olav", config)
               [["children"]][[1]][["children"]][[1]]
               [["children"]][[1]][["children"]][[1]]
               [["children"]][[1]],
               config$app_text$table$main_column)
})
