test_that("mod_quality_overview_server", {
    shiny::testModule(mod_quality_overview_server, {
        session$setInputs(pick_treatment_unit = "Oslofjordklinikken")
        session$setInputs(pick_year = "2018")

        expect_equal(output$year[["deps"]][[1]][["name"]], "selectize")
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]], "selectize")
#        expect_error(output$qi_table) # As long as app is broken.
        expect_equal(output$qi_table[["deps"]][[1]][["name"]], "font-awesome")
    })
})
