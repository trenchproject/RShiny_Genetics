library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magrittr)
library(plotly)
library(dplyr)


pkgs <- c("shiny", "shinythemes", "shinyWidgets", "magrittr", "plotly", "dplyr", "asd")
lapply(pkgs, library, character.only = TRUE)

lapply(pkgs, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
    }
  }
)



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
  theme = shinytheme("united"),
  setBackgroundColor(color = "#F5F5F5"), 
  title = "Plasticity trade-off",
  titlePanel("Does evolving tolerance of hot temperatures limit acclimation capacity?"),
  hr(),
  includeHTML("intro.html"),
  
  # sidebarLayout(
  #   sidebarPanel(
  #     checkboxGroupButtons("hypothesis", "Hypothesis", choices = c("Hypothesis 1", "Hypothesis 2"))
  #   ),
  #   
  #   mainPanel(
  radioGroupButtons("hypothesis", "", choices = c("Assumption" = 0, "Latitudinal hypothesis" = 1, "Trade-off hypothesis"), selected = NA, status = "danger", size = "sm"),
      
  uiOutput("plotOptions"),
  htmlOutput("beetlestats"),
  #   )
  # ),

 br(), br(), br(),
 includeHTML("section2.html"),
 br(),
  sidebarLayout(
    sidebarPanel(
      pickerInput("taxa", "Select taxa", choices = Taxa, selected = "All",
                  options = list(style = "btn-success", `actions-box` = TRUE)),
      uiOutput("habitatInput"),
      hr(),
      pickerInput("dependent", "Dependent variable", choices = ytitle, 
                  options = list(style = "btn-success")),
      br(),
      #materialSwitch("trend", "Trend line", value = TRUE, status = "danger"),
      width = 3
    ),
    
    mainPanel(
      plotlyOutput("plot1"),
      fluidRow(
        column(4, offset = 4, 
               pickerInput("independent", "Independent variable", choices = xtitle, 
                           options = list(style = "btn-success")))
      ),
      br(),
      htmlOutput("stats"),
      width = 9
    )
  ),
  
  hr()
  
)
