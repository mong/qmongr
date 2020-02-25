test_that("config", {
  if (file.exists("_qmongr.yml")) {
    file.remove("_qmongr.yml")
  }
  expect_error(has_config("_qmongr.yml"))
  expect_equal(create_config(), "_qmongr.yml file copied: fill it in")
  expect_equal_to_reference(get_config("_qmongr.yml"), "data/get_config.rds")
  expect_null(has_config("_qmongr.yml"))
  expect_null(check_config(readRDS("data/get_config.rds")))
  expect_equal(create_config(), "Cannot create _qmongr.yml config file: already exists")
  expect_null(has_config("_qmongr.yml"))
  file.remove("_qmongr.yml")
  expect_error(has_config("_qmongr.yml"))
  expect_error(check_config("qwerty"))
})
