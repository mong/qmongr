test_that("add_external_resources", {
  expect_equal_to_reference(add_external_resources(),
                            "data/add_external_resources.rds"
                            )
})
