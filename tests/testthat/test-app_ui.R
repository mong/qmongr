test_that("app_ui", {
  config <- get_config()
  ref_chr <- as.character(purrr::flatten(app_ui()))[4]

  expect_true(grepl("shiny-html-output", ref_chr, fixed = TRUE))
})
