test_that("add external resources works", {
  expect_equal(qmongr::add_external_resources()$name, "head")
})
