test_that("string is returned when querying version info on pkgs defined in config", {
  expect_equal(class(version_info()), "character")
})

test_that("configured ok messages can be retreived", {
  expect_equal(class(no_opt_out_ok()), "character")
})

test_that("ok message samling works, e.g. different messages are provided", {
  f <- function() {
    no_opt_out_ok()
  }
  expect_false(identical(c(f(), f()), c(f(), f())))
})
