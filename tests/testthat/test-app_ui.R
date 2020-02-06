test_that("app ui works", {
  expect_equal(unlist(qmongr::app_ui())[["name"]], "head")
  expect_equal(unlist(qmongr::app_ui())[["children.name"]], "link")
})
