test_that("app_server", {
  expect_error(app_server())
  shiny::testModule(app_server, {
    expect_equal(class(input), "reactivevalues")
    expect_equal(class(output), "shinyoutput")

    session$setInputs(pick_year = "2018")
    expect_equal(input$pick_year, "2018")
    session$setInputs(pick_treatment_units = "Trondheim")
    expect_equal(input$pick_year, "2018")
    expect_equal(input$pick_treatment_units, "Trondheim")
    session$setInputs(qwerty = "Trondheim")
    expect_equal(input$pick_year, "2018")
    expect_equal(input$pick_treatment_units, "Trondheim")
    expect_equal(input$qwerty, "Trondheim")
  })
})
