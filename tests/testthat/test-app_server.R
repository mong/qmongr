test_that("app server works", {
  expect_equal(qmongr::app_server(), NULL)
})
