test_that("app ui works", {
  expect_equal(typeof(qmongr::app_ui()), "list")
})
