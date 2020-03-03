test_that("app server works", {
  expect_error(qmongr::app_server())
  shiny::testModule(app_server, {
    expect_equal(class(input), "reactivevalues")
    expect_null(input$Values)
    expect_null(input$Readonly)
    expect_equal(class(output), "shinyoutput")
  })
})
