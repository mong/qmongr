test_that("add external resources works", {
  expect_equal(typeof(qmongr::add_external_resources()), "list")
})
