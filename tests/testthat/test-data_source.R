test_that("function returns static data as list provided by thepackage", {
  expect_equal(class(agg_data()), "list")
})
