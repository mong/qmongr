test_that("mod_quality_overview_server", {
    shiny::testModule(mod_quality_overview_server, {
        expect_equal(class(input), "reactivevalues")
        expect_equal(class(output), "shinyoutput")

        expect_equal(class(output$treatment_unit[["html"]]),
                     c("html", "character"))
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]],
                     "selectize")

        treatment_units <- as.character(output$treatment_unit[["html"]])
        expect_true(grepl("Hammerfest", treatment_units))
        expect_true(grepl("Troms\u00f8", treatment_units))
        expect_true(grepl("shiny-input-container", treatment_units))
        expect_true(grepl("mock-session-pick_treatment_units", treatment_units))
        expect_true(grepl("<optgroup label=\"RHF\">", treatment_units))
        expect_true(grepl("Mo i Rana", treatment_units))

        expect_equal_to_reference(output$year[["html"]],
                                  "data/output_year_html.rds")
        expect_equal(class(output$year[["html"]]),
                     c("html", "character"))
        expect_equal(output$year[["deps"]][[1]][["name"]],
                     "selectize")

        expect_error(output$qi_table)

        session$setInputs(pick_treatment_units = "Trondheim")
        expect_error(output$qi_table)

        session$setInputs(pick_year = "2018")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_trondheim_2018.rds")
        session$setInputs(pick_year = "2016")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_trondheim_2016.rds")
        session$setInputs(pick_year = "2017")

        session$setInputs(pick_treatment_units = "Troms\u00f8")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_tromso_2017.rds")

        session$setInputs(pick_treatment_units = "Helse Nord RHF")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_helse_nord_2017.rds")
        session$setInputs(pick_treatment_units = "Private")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_qwerty.rds")
        session$setInputs(pick_year = "2019")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_private_2019.rds")
        session$setInputs(pick_treatment_units = "Bergen")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_bergen_2019.rds")

        session$setInputs(pick_treatment_units = c("Molde", "Helgeland", "Helse Vest RHF"))
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_multiple_2019.rds")

        session$setInputs(pick_treatment_units = "Trondheim")
        session$setInputs(pick_year = c("2017", "2018", "2019"))
        expect_null(output$qi_table)

        session$setInputs(pick_year = "qwerty")
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_qwerty.rds")
        suppressWarnings(session$setInputs(pick_treatment_units = "qwerty"))
        expect_equal_to_reference(output$qi_table, "data/output_qi_table_qwerty.rds")

        suppressWarnings(session$setInputs(pick_year = "2019"))
        suppressWarnings(session$setInputs(pick_treatment_units = "Førde"))
        expect_error(output$qi_table)
    })
})

test_that("mod_quality_overview_ui", {
    config <- get_config()
    ref_chr <- as.character(purrr::flatten(mod_quality_overview_ui("test")))[3]

    expect_true(grepl(config$app_text$menus$unit, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$menus$year, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$indicators$high, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$indicators$moderate, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$indicators$low, ref_chr, fixed = TRUE))

    expect_true(grepl("test-treatment_unit", ref_chr, fixed = TRUE))
    expect_true(grepl("shiny-html-output", ref_chr, fixed = TRUE))
    expect_true(grepl("test-year", ref_chr, fixed = TRUE))
    expect_true(grepl("high", ref_chr, fixed = TRUE))
    expect_true(grepl("moderate", ref_chr, fixed = TRUE))
    expect_true(grepl("low", ref_chr, fixed = TRUE))
    expect_true(grepl("test-qi_overview", ref_chr, fixed = TRUE))
    expect_true(grepl("test-qi_table", ref_chr, fixed = TRUE))

    ref_chr <- as.character(purrr::flatten(mod_quality_overview_ui("qwerty")))[3]
    expect_false(grepl("test-treatment_unit", ref_chr, fixed = TRUE))
    expect_false(grepl("test-year", ref_chr, fixed = TRUE))
    expect_false(grepl("test-qi_overview", ref_chr, fixed = TRUE))
    expect_false(grepl("test-qi_table", ref_chr, fixed = TRUE))
})
