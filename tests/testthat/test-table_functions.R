
test_that("load_data", {

  expect_type(load_data(), "list")

  expect_equal(
    names(load_data()),
    c("description", "indicator", "hospital_name_structure")
  )

  expect_equal(
    names(load_data(data_type = "all")),
    c("description", "indicator", "hospital_name_structure")
  )

  expect_equal(
    names(load_data("description")),
    "description"
  )

  expect_equal(
    names(load_data(data_type = "indicator")),
    "indicator"
  )

  expect_equal(
    names(load_data("hospital_name_structure")),
    "hospital_name_structure"
  )

  qm_data <- readRDS("data/load_data1.rds")

  expect_equal(
    names(load_data("description")[["description"]]), names(qm_data$description)
  )

  expect_equal(
    names(load_data("hospital_name_structure")[["hospital_name_structure"]]),
    names(qm_data$hospital_name_structure)
  )

  expect_equal(
    names(load_data("indicator")[["indicator"]]),
    names(qm_data$indicator)
  )
})
