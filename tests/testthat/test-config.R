test_that("create_config", {
  expect_equal(create_config(dir = "data"), "Cannot create data/_qmongr.yml config file: already exists")

  expect_equal(create_config(), "./_qmongr.yml file created: fill it in")
  file.remove("_qmongr.yml")
})

test_that("check_config", {
  test_config <- readRDS("data/get_config.rds")
  expect_null(check_config(test_config))

  test_config <- NULL
  expect_error(check_config(test_config))

  test_config <- list()
  expect_error(check_config(test_config))

  test_config <- list("a" = 2.5, "b" = TRUE)
  expect_error(check_config(test_config))

  expect_error(check_config("qwerty"))
})

test_that("get_config", {
  expect_equal_to_reference(get_config(dir = "data"), "data/get_config.rds")

  # This will fail if default version of qmongr.yml has been changed.
  expect_equal_to_reference(get_config(), "data/get_config_default.rds")
})
