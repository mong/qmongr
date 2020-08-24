text_file_tester <- function(data, ref_file) {
  if (!file.exists(ref_file)) {
    print(paste("The reference file", ref_file,
                "does not exists, so we will create it"))
    my_file <- file(ref_file, encoding = "UTF-8")
    writeLines(as.character(data), my_file)
    close(my_file)
    return(TRUE)
  } else {
    # Read the reference file
    my_file <- file(ref_file, encoding = "UTF-8")
    rhs <- readLines(my_file)
    close(my_file)

    # Turn R object into vector of characters
    lhs <- as.character(data) %>%
      strsplit(split = "\n") %>%
      unlist()

    identical(lhs, rhs)
  }
}

test_that("quality_overview_server without input", {
    shiny::testServer(quality_overview_server, {
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
        expect_true(grepl("proxy1-pick_treatment_units", treatment_units))
        expect_true(grepl("<optgroup label=\"RHF\">", treatment_units))
        expect_true(grepl("Mo i Rana", treatment_units))

        expect_true(text_file_tester(output$year[["html"]],
                                     "data/output_year_html.html"))
        expect_equal(class(output$year[["html"]]),
                     c("html", "character"))
        expect_equal(output$year[["deps"]][[1]][["name"]],
                     "selectize")

        expect_null(output$qi_table)
    })
})

test_that("quality_overview_server without treatment unit", {
  shiny::testServer(quality_overview_server, {
    session$setInputs(pick_treatment_units = NULL)
    session$setInputs(pick_year = "2018")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_default_2018.html"))
  })
})


test_that("quality_overview_server errors", {
  shiny::testServer(quality_overview_server, {
    session$setInputs(pick_treatment_units = "Trondheim")
    expect_null(output$qi_table)

    session$setInputs(pick_treatment_units = "Trondheim")
    session$setInputs(pick_year = c("2017", "2018", "2019"))
    expect_null(output$qi_table)

    session$setInputs(pick_year = "qwerty")
    expect_true(text_file_tester(output$qi_table[["html"]], "data/output_qi_table_empty.html"))

    suppressWarnings(session$setInputs(pick_treatment_units = "qwerty"))
    expect_true(text_file_tester(output$qi_table[["html"]], "data/output_qi_table_empty.html"))
  })
})

test_that("quality_overview_server basic input", {
  shiny::testServer(quality_overview_server, {
    session$setInputs(pick_treatment_units = "Trondheim")
    session$setInputs(pick_year = "2018")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_trondheim_2018.html"))
    session$setInputs(pick_year = "2016")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_trondheim_2016.html"))
    session$setInputs(pick_year = "2017")

    session$setInputs(pick_treatment_units = "Troms\u00f8")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_tromso_2017.html"))

    session$setInputs(pick_treatment_units = "Helse Nord RHF")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_helse_nord_2017.html"))

    session$setInputs(pick_treatment_units = "Private")
    expect_true(text_file_tester(output$qi_table[["html"]],
                              "data/output_qi_table_empty.html"))
    session$setInputs(pick_year = "2019")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_private_2019.html"))
    session$setInputs(pick_treatment_units = "Bergen HF")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_bergen_2019.html"))

    session$setInputs(pick_treatment_units = c("Molde",
                                               "Helgeland HF",
                                               "Helse Vest RHF"
                                               ))
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_multiple_2019.html"))

    suppressWarnings(session$setInputs(pick_year = "2019"))
    suppressWarnings(session$setInputs(pick_treatment_units = "Førde"))
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_forde_2019.html"))
  })
})

test_that("quality_overview_server filter medical field", {
  shiny::testServer(quality_overview_server, {

    session$setInputs(pick_year = "2017")
    session$setInputs(pick_treatment_units =  "Helse Nord RHF")

    session$setInputs(intensiv = 1)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_intensiv.html"))

    session$setInputs(alle = 1)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_helse_nord_2017.html"))

    session$setInputs(pick_year = "2018")
    session$setInputs(pick_treatment_units =  "Bergen HF")
    session$setInputs(tarm = 1)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_tarm.html"))
    session$setInputs(pick_year = "2019")
    expect_true(text_file_tester(output$qi_table[["html"]],
                              "data/output_qi_table_empty.html"))

    session$setInputs(pick_year = "2018")
    session$setInputs(muskel = 1)
    session$setInputs(pick_treatment_units = "Bergen HF")
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_muskel.html"))

    session$setInputs(pick_treatment_units =  "Skien")
    expect_true(text_file_tester(output$qi_table[["html"]],
                              "data/output_qi_table_empty_skien.html"))
  })
})

test_that("quality_overview_server filter level", {
  shiny::testServer(quality_overview_server, {
    session$setInputs(pick_year = 2017)
    session$setInputs(pick_treatment_units =  "Helse Vest RHF")
    session$setInputs(legend_high = 1)
    session$setInputs(legend_mod = 0)
    session$setInputs(legend_low = 0)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_level_high_2017.html"))

    session$setInputs(legend_high = 1)
    session$setInputs(legend_high = 1)
    session$setInputs(legend_mod = 0)
    session$setInputs(legend_low = 0)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_level_high_2017.html"))

    session$setInputs(pick_treatment_units =  "UNN HF")
    session$setInputs(pick_year = 2018)
    session$setInputs(legend_high = 0)
    session$setInputs(legend_mod = 1)
    session$setInputs(legend_low = 0)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_filter_level_mod_2018.html"))

    session$setInputs(pick_treatment_units = "Akershus HF")
    session$setInputs(legend_high = 0)
    session$setInputs(legend_mod = 0)
    session$setInputs(legend_low = 1)
    expect_true(text_file_tester(output$qi_table[["html"]],
                                 "data/output_qi_table_level_low_2018.html"))
  })
})

test_that("quality_overview_ui", {
    config <- get_config()
    ref_chr <- as.character(purrr::flatten(quality_overview_ui("test")))[3]

    expect_true(grepl(config$app_text$indicators$high, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$indicators$moderate, ref_chr, fixed = TRUE))
    expect_true(grepl(config$app_text$indicators$low, ref_chr, fixed = TRUE))

    expect_true(grepl("quality_overview_ui_1-treatment_unit", ref_chr, fixed = TRUE))
    expect_true(grepl("shiny-html-output", ref_chr, fixed = TRUE))
    expect_true(grepl("quality_overview_ui_1-year", ref_chr, fixed = TRUE))
    expect_true(grepl("high", ref_chr, fixed = TRUE))
    expect_true(grepl("moderate", ref_chr, fixed = TRUE))
    expect_true(grepl("low", ref_chr, fixed = TRUE))
    expect_true(grepl("test-qi_overview", ref_chr, fixed = TRUE))
    expect_true(grepl("test-qi_table", ref_chr, fixed = TRUE))

    ref_chr <- as.character(purrr::flatten(quality_overview_ui("qwerty")))[3]
    expect_false(grepl("test-treatment_unit", ref_chr, fixed = TRUE))
    expect_false(grepl("test-year", ref_chr, fixed = TRUE))
    expect_false(grepl("test-qi_overview", ref_chr, fixed = TRUE))
    expect_false(grepl("test-qi_table", ref_chr, fixed = TRUE))
})

test_that("info pop-up can be activated", {
    shiny::testServer(quality_overview_server, {
        # bump the action button value to trigger pop-up
        session$setInputs(app_info = 10)
        # no actual testing of pop-up per se, any output will do
        expect_true(grepl("button", output$app_info$html))
    })
})
