test_that("app_server", {
  expect_true("Observer" %in% class(app_server()))
})
