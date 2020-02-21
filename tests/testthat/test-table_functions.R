
test_that("load_data", {

  expect_type(qmongr::load_data(), "list")

  expect_equal(
    names(qmongr::load_data()),
    c("description", "indicator")
  )

  expect_equal(
    names(qmongr::load_data("description")),
    "description"
  )

  expect_equal(
    names(qmongr::load_data("indicator")), "indicator")
})



test_that("filter_data", {
  nkr_data <- readRDS("data/load_data1.rds")

  expect_equal_to_reference(qmongr::filter_data(nkr_data), "data/filter_data1.rds")
  expect_equal_to_reference(qmongr::filter_data(nkr_data,
                                                filter_settings = list(Aar = 2017, ShNavn = "Trondheim, St. Olav")),
                            "data/filter_data2.rds")

  expect_type(qmongr::filter_data(nkr_data), "list")

  expect_equal(
    unique(qmongr::filter_data(
      nkr_data,
      filter_settings = list(Aar = 2015))[["indicator"]][["Aar"]]),
    2015)

  expect_equal(
    unique(qmongr::filter_data(
      nkr_data,
      filter_settings = list(ShNavn = "OUS, RH"))[["indicator"]][["ShNavn"]]),
    "OUS, RH")
})


test_that("aggregate_data", {
  filtered_nkr1 <- readRDS("data/filter_data1.rds")
  expect_equal_to_reference(qmongr::aggregate_data(filtered_nkr1), "data/aggregate_data1.rds")
  filtered_nkr2 <- readRDS("data/filter_data2.rds")
  expect_equal_to_reference(qmongr::aggregate_data(filtered_nkr2), "data/aggregate_data2.rds")
})


test_that("compute_indicator works", {

  agg_nkr <- readRDS("data/aggregate_data1.rds")
  expect_equal_to_reference(qmongr::compute_indicator(agg_nkr), "data/compute_indicator1.rds")

  agg_nkr2 <- readRDS("data/aggregate_data2.rds")
  expect_equal_to_reference(qmongr::compute_indicator(agg_nkr2), "data/compute_indicator2.rds")
})

test_that("compute_national_indicator", {
  nkr_data <- readRDS("data/load_data1.rds")
  expect_equal_to_reference(qmongr::compute_national_indicator(nkr_data[["indicator"]]),
                            "data/compute_national_indicator1.rds")
})
