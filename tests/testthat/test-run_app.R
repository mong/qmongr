test_that("run app works", {
  expect_equal(typeof(qmongr::run_app()), "list")
})
