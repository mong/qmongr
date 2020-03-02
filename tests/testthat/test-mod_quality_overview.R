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

test_that("mod_quality_overview_ui", {
    # These tests are fragile, since they are depending on the order of elements in shiny output.
    high_level <- mod_quality_overview_ui("test")[[1]][[3]][[1]]
    expect_equal(high_level[["attribs"]][["class"]],
                 "container-fluid")
    expect_equal(high_level[["children"]][[1]][["attribs"]][["class"]],
                 "treatment_unit")

    children_one <- high_level[["children"]][[1]][["children"]][[1]]
    expect_equal(children_one[["children"]][[1]][["children"]][[1]][["children"]][[1]],
                 "Velg behandlingssted:")
    expect_equal(children_one[["children"]][[2]][["children"]][[1]][["attribs"]][["id"]],
                 "test-treatment_unit")
    expect_equal(children_one[["children"]][[3]][["children"]][[1]][["children"]][[1]],
                 "Velg år:")
    expect_equal(children_one[["children"]][[4]][["children"]][[1]][["attribs"]][["id"]],
                 "test-year")

    children_two <- high_level[["children"]][[2]][["children"]][[1]][["children"]][[1]][["children"]][[1]]
    expect_equal(children_two[["children"]][[1]][["children"]][[2]],
                 "H\u00F8y m\u00E5loppn\u00E5else")
    expect_equal(children_two[["children"]][[2]][["children"]][[2]],
                 "Moderat m\u00E5loppn\u00E5else")
    expect_equal(children_two[["children"]][[3]][["children"]][[2]],
                 "Lav m\u00E5loppn\u00E5else")
})
