test_that("config", {
  if (file.exists("_qmongr.yml")) {
    file.remove("_qmongr.yml")
  }
  expect_equal(create_config(), "_qmongr.yml file copied: fill it in")
  expect_equal(create_config(), "Cannot create _qmongr.yml config file: already exists")
  file.remove("_qmongr.yml")
})