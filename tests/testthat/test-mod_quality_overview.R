test_that("mod_quality_overview_server", {
    shiny::testModule(mod_quality_overview_server, {
        expect_equal(class(input), "reactivevalues")
        expect_equal(class(output), "shinyoutput")

        expect_equal_to_reference(output$treatment_unit[["html"]], "data/output_treatment_unit_html.rds")
        expect_equal(class(output$treatment_unit[["html"]]), c("html", "character"))
        expect_equal(output$treatment_unit[["deps"]][[1]][["name"]], "selectize")

        expect_equal_to_reference(output$year[["html"]], "data/output_year_html.rds")
        expect_equal(class(output$year[["html"]]), c("html", "character"))
        expect_equal(output$year[["deps"]][[1]][["name"]], "selectize")
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
