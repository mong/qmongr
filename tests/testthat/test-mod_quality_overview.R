test_that("mod_quality_overview_server", {
    shiny::testModule(mod_quality_overview_server, {

        # Table without defined pick_treatment_unit and pick_year
        expect_error(output$qi_table)

        session$setInputs(pick_treatment_unit = "Oslofjordklinikken")

        # Table without defined pick_year
        expect_error(output$qi_table)

        session$setInputs(pick_year = "2018")

        expect_true(grepl("Oslofjordklinikken", as.character(output$qi_table$html), fixed = TRUE))
        expect_false(grepl("Aker", as.character(output$qi_table$html), fixed = TRUE))
        expect_true(grepl("2018", as.character(output$qi_table$html), fixed = TRUE))
        expect_true(grepl("Oslofjordklinikken", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("Aker", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("2016", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2017", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2018", as.character(output$year$html), fixed = TRUE))

        # Change treatment unit
        session$setInputs(pick_treatment_unit = "Aker")
        session$setInputs(pick_year = "2018")
        expect_true(grepl("Aker", as.character(output$qi_table$html), fixed = TRUE))
        expect_false(grepl("Oslofjordklinikken", as.character(output$qi_table$html), fixed = TRUE))
        expect_true(grepl("2018", as.character(output$qi_table$html), fixed = TRUE))
        expect_true(grepl("Oslofjordklinikken", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("Aker", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("2016", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2017", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2018", as.character(output$year$html), fixed = TRUE))

        # Select non-selectable hospital
        session$setInputs(pick_treatment_unit = "qwerty")
        session$setInputs(pick_year = "2018")
        expect_error(output$qi_table)
        expect_true(grepl("Oslofjordklinikken", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("Aker", as.character(output$treatment_unit$html), fixed = TRUE))
        # Not sure why these suddenly are false...
        expect_false(grepl("2016", as.character(output$year$html), fixed = TRUE))
        expect_false(grepl("2017", as.character(output$year$html), fixed = TRUE))
        expect_false(grepl("2018", as.character(output$year$html), fixed = TRUE))

        # Select non-selectable year
        session$setInputs(pick_treatment_unit = "Oslofjordklinikken")
        session$setInputs(pick_year = "qwerty")
        expect_error(output$qi_table)
        expect_true(grepl("Oslofjordklinikken", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("Aker", as.character(output$treatment_unit$html), fixed = TRUE))
        expect_true(grepl("2016", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2017", as.character(output$year$html), fixed = TRUE))
        expect_true(grepl("2018", as.character(output$year$html), fixed = TRUE))
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
