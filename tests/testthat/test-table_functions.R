
test_that("load_data", {

  expect_type(qmongr::load_data(), "list")

  expect_equal(
    names(qmongr::load_data()),
    c("description", "indicator", "hospital_name_structure")
  )

  expect_equal(
    names(qmongr::load_data(data_type = "all")),
    c("description", "indicator", "hospital_name_structure")
  )

  expect_equal(
    names(qmongr::load_data("description")),
    "description"
  )

  expect_equal(
    names(qmongr::load_data(data_type = "indicator")),
    "indicator"
  )

  expect_equal(
    names(qmongr::load_data("hospital_name_structure")),
    "hospital_name_structure"
  )
})
