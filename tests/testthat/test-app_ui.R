test_that("app_ui", {
  expect_equal_to_reference(app_ui(), "data/app_ui.rds")
})
