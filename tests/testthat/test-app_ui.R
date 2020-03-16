test_that("app_ui", {
  config <- get_config()
  ref_chr <- as.character(purrr::flatten(app_ui()))[4]

  expect_true(grepl("treatment_unit", ref_chr, fixed = TRUE))
  expect_true(grepl("quality_overview_ui_1-qi_overview", ref_chr, fixed = TRUE))
  expect_true(grepl(config$app_text$indicators$high, ref_chr, fixed = TRUE))
  expect_true(grepl(config$app_text$indicators$moderate, ref_chr, fixed = TRUE))
  expect_true(grepl(config$app_text$indicators$low, ref_chr, fixed = TRUE))

  expect_true(grepl("shiny-html-output", ref_chr, fixed = TRUE))
  expect_true(grepl("high", ref_chr, fixed = TRUE))
  expect_true(grepl("moderate", ref_chr, fixed = TRUE))
  expect_true(grepl("low", ref_chr, fixed = TRUE))
})
