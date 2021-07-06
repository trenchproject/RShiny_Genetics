library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magrittr)
library(plotly)
library(dplyr)
library(cicerone)
library(shinyjs)
library(shinyBS)

# pkgs <- c("shiny", "shinythemes", "shinyWidgets", "magrittr", "plotly", "dplyr", "cicerone)
# lapply(pkgs, library, character.only = TRUE)
# 
# lapply(pkgs, FUN = function(x) {
#     if (!require(x, character.only = TRUE)) {
#       install.packages(x, dependencies = TRUE)
#     }
#   }
# )

Taxa <- c("All", "Amphibians" = "amph", "Crustaceans" = "crust", "Fish" = "fish", "Insects" = "insect", "Reptiles" = "rept")

xtitle <- c("Upper thermal limit (°C)" = "MaxCtmax", 
            "Lower thermal limit (°C)" = "MinCtmin",
            "Thermal tolerance range (°C)" = "TTR",
            "Delta upper thermal limit (°C)" = "CtmaxARR",
            "Seasonality (°C)" = "Seasonality", 
            "Latitude (°)" = "Latitude")

ytitle <- c("Delta upper thermal limit (°C)" = "CtmaxARR", 
            "Delta lower thermal limit (°C)" = "CtminARR", 
            "Seasonality (°C)" = "Seasonality", 
            "Upper thermal limit (°C)" = "MaxCtmax", 
            "Thermal tolerance range (°C)" = "TTR")


shinyUI <- fluidPage(
  use_cicerone(),
  useShinyjs(),
  theme = shinytheme("united"),
  setBackgroundColor(color = "#C7DAE0"),
  titlePanel(
    div(tags$img(src="TrenchEdLogo.png", height = 150), 
        "Heat Tolerance vs Acclimation Capacity?")
  ),
  title = "Plasticity trade-off",
  hr(),
  includeHTML("intro.html"),
  br(),

  actionBttn(
    inputId = "tour1",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ),
  hr(),
  
  radioGroupButtons("hypothesis", "", choices = c("Assumption" = 0, "Latitudinal hypothesis" = 1, "Trade-off hypothesis" = 2), selected = NA, status = "danger", size = "sm"),
  uiOutput("plotOptions"),
  htmlOutput("beetlestats"),

  br(), br(),
  includeHTML("section2.html"),
  br(),
  actionBttn(
    inputId = "reset2",
    label = "Reset", 
    style = "material-flat",
    color = "danger",
    size = "xs"
  ),
  bsTooltip("reset2", "If you have already changed the variables, reset them to default here before starting the tour."),
  
  actionBttn(
    inputId = "tour2",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ),
  hr(),
  div(
    id = "Gunderson-wrapper",
    sidebarLayout(
      sidebarPanel(
        div(
          id = "taxa-wrapper",
          pickerInput("taxa", "Select taxa", choices = Taxa, selected = "All",
                      options = list(style = "btn-success", `actions-box` = TRUE))
        ),
        uiOutput("habitatInput"),
        hr(),
        div(
          id = "dependent-wrapper",
          pickerInput("dependent", "Dependent variable", choices = ytitle, 
                      options = list(style = "btn-success"))
        ),
        br(),
        #materialSwitch("trend", "Trend line", value = TRUE, status = "danger"),
        width = 3
      ),
    
      mainPanel(
        plotlyOutput("plot"),
        div(
          id = "independent-wrapper",
          fluidRow(
            column(4, offset = 4, 
                   pickerInput("independent", "Independent variable", choices = xtitle, 
                               options = list(style = "btn-success")))
          )
        ),
        br(),
        htmlOutput("stats"),
        width = 9
      )
    )
  ),
  
  hr()
)
