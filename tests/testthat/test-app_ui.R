test_that("app_ui", {
  config <- get_config()
  ref_chr <- as.character(purrr::flatten(app_ui()))[1]

  expect_true(grepl("head", ref_chr, fixed = TRUE))
})
