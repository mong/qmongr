test_that("pipe", {
  expect_equal(sum(seq(1,4)), seq(1,4) %>% sum())
})
