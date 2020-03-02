test_that("mod_quality_overview_server", {
    shiny::testModule(mod_quality_overview_server, {
        session$setInputs(pick_treatment_unit = "Oslofjordklinikken")
        session$setInputs(pick_year = "2018")

        expect_equal(output$year[["deps"]][[1]][["name"]], "selectize")
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]], "selectize")
        expect_equal(output$qi_table[["deps"]][[1]][["name"]], "font-awesome")

        # The following test should fail if app is working!
        session$setInputs(pick_treatment_unit = "Aker")
        expect_error(output$qi_table) # As long as app is broken.

        # Select non-selectable hospital
        session$setInputs(pick_treatment_unit = "qwerty")
        expect_error(output$qi_table)
        expect_equal(output$year[["deps"]][[1]][["name"]], "selectize")
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]], "selectize")
        
        # Select non-selectable year
        session$setInputs(pick_treatment_unit = "Oslofjordklinikken")
        session$setInputs(pick_year = "qwerty")
        expect_error(output$qi_table)
        expect_equal(output$year[["deps"]][[1]][["name"]], "selectize")
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]], "selectize")

    })
})
