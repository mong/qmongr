test_that("config", {
  expect_equal(create_config(), "Cannot create _qmongr.yml config file: already exists")
  expect_equal_to_reference(get_config(), "data/get_config.rds")
  expect_null(check_config(readRDS("data/get_config.rds")))
  expect_error(check_config("qwerty"))
})
