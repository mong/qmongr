# Module UI

#' @title   mod_quality_overview_ui and mod_quality_overview_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_quality_overview
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
mod_quality_overview_ui <- function(id) {
  ns <- shiny::NS(id)
  config <- qmongr::get_config()
  tagList(
    shiny::fluidPage(
      shiny::tags$div(
        class = "treatment_unit",
        shiny::fluidRow(
          shiny::column(
            width = 3,
            shiny::tags$h3(config$app_text$menus$unit)
          ),
          shiny::column(
            width = 3,
            shiny::uiOutput(outputId = ns("treatment_unit"))
          ),
          shiny::column(
            width = 2,
            shiny::tags$h3(config$app_text$menus$year)
          ),
          shiny::column(
            width = 2,
            shiny::uiOutput(outputId = ns("year"))
          )
        )
      ),
      shiny::tags$div(
        class = "table_legend",
        shiny::fluidRow(
          shiny::column(
            width = 7,
            offset = 4,
            shiny::tags$ul(
              shiny::tags$li(class = "high",
                shiny::icon("fas fa-circle"),
                config$app_text$indicators$high),
              shiny::tags$li(class = "moderate",
                shiny::icon("fas fa-adjust"),
                config$app_text$indicators$moderate),
              shiny::tags$li(class = "low",
                shiny::icon("circle-o"),
                config$app_text$indicators$low),
            )
          )
        )
      ),
      shiny::fluidRow(
        shiny::column(
          offset = 1,
          width = 2,
          shiny::uiOutput(
            outputId = ns("qi_overview")
          )
        ),
        shiny::column(
          width = 8,
          shiny::uiOutput(
            outputId = ns("qi_table")
          )
        )
      )
    )
  )
}

# Module Server

#' @rdname mod_quality_overview
#' @importFrom rlang .data
#' @export
#' @keywords internal

mod_quality_overview_server <- function(input,
                                        output,
                                        session) {

  ns <- session$ns
  config <- qmongr::get_config()
  register_data <- qmongr::load_data()
  grouped_by_HF <- qmongr::group_data(register_data, by = "HF") %>% 
      dplyr::left_join(
        register_data[["hospital_name_structure"]] %>% 
          dplyr::select( 
            .data[["HF"]],
            .data[["OrgNrHF"]]
          ) %>%
          unique(),
        by = "OrgNrHF"
      )
  grouped_by_RHF <- qmongr::group_data(
    register_data,
    by = "RHF"
  ) %>% 
    dplyr::left_join(
      register_data[["hospital_name_structure"]] %>% 
        dplyr::select( 
          .data[["RHF"]],
          .data[["OrgNrRHF"]]
        ) %>% 
        unique(),
      by = "OrgNrRHF"
    )
  grouped_by_hospital <- qmongr::group_data(
    register_data,
    by = "hospital"
  ) %>% 
    dplyr::left_join(
      register_data[["hospital_name_structure"]] %>%
        dplyr::select(
          .data[["SykehusNavn"]],
          .data[["OrgNrShus"]]
        ) %>%
        dplyr::mutate(
          "OrgNrShus" = as.character(.data[["OrgNrShus"]])),
      by = c("SykehusId" = "OrgNrShus"),
    ) %>%
    dplyr::filter(!is.na(.data[["SykehusNavn"]]))
  
  national_data <- qmongr::group_data(
    register_data,
    by = ""
  )


  output$qi_table <- shiny::renderUI({
    selected_units <- list()
    selected_units$RHF <- input$pick_treatment_units[
      req(input$pick_treatment_units) %in%
      choices_treatment$RHF]
    selected_units$HF <- input$pick_treatment_units[
      req(input$pick_treatment_units) %in%
        choices_treatment$HF]
    selected_units$SykehusNavn <- input$pick_treatment_units[
      req(input$pick_treatment_units) %in%
        choices_treatment$Sykehus]
    
    selected_data <- list()
    if(!rlang::is_empty(selected_units$RHF)) {
      selected_data$RHF <- grouped_by_RHF %>% 
        dplyr::filter(
          .data[["RHF"]] %in% selected_units$RHF,
          .data[["count"]] > 5,
          .data[["Aar"]] == input$pick_year)
    }
    
    if(!rlang::is_empty(selected_units$HF)) {
      selected_data$HF <- grouped_by_HF %>% 
        dplyr::filter(
          .data[["HF"]] %in% selected_units$HF,
          .data[["count"]] > 5,
          .data[["Aar"]] == input$pick_year)
    }
    if(!rlang::is_empty(selected_units$Sykehus)) {
      selected_data$SykehusNavn <- grouped_by_hospital %>% 
        dplyr::filter(
          .data[["SykehusNavn"]] %in% selected_units$SykehusNavn,
          .data[["count"]] > 5,
          .data[["Aar"]] == input$pick_year)
    }
    
    selected_data$national <- national_data
    
    
    qmongr::qi_table(selected_data, selected_units, config)
  })

  choices_treatment <- list(
    "RHF" = grouped_by_RHF$RHF %>%
      unique() %>%
      sort(),
    "HF" = grouped_by_HF$HF %>%
      unique() %>%
      sort(), 
    "Sykehus" = grouped_by_hospital$SykehusNavn %>%
      unique() %>%
      sort())
 
  output$treatment_unit <- shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("pick_treatment_units"),
      choices =  choices_treatment,
      multiple = TRUE
    )
  })
  
  output$year <-  shiny::renderUI({
    shiny::selectInput(
      label = NULL,
      inputId = ns("pick_year"),
      choices = c(2016,2017,2018,2019) %>%
        sort(decreasing = T)

    )
  })
 
 


}
