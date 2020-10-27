# df <- read_excel("Gunderson&Stillman_data.xlsx", 
#                  col_types = c("text", "text", "text", 
#                                "numeric", "numeric", "numeric", 
#                                "numeric", "numeric", "text", "numeric", 
#                                "numeric", "numeric", "numeric", 
#                                "numeric", "text")) 
# 
# df <- df %>% as.data.frame()
# write.csv(df, "Gunderson&Stillman_data.csv")

data <- read.csv("Gunderson&Stillman_data.csv")

data$Latitude <- abs(data$Latitude)
data$TTR <- data$MaxCtmax - data$MinCtmin

beetles <- read.csv("beetles_data.csv")
beetles$MeanUTL <- (beetles$UTL14.5 + beetles$UTL20.5) / 2
beetles$MeanLTL <- (beetles$LTL14.5 + beetles$LTL20.5) / 2

beetles <- beetles[-1, ]
habitats <- c("t" = "Terrestrial", "sw" = "Marine", "fw" = "Freshwater")

xtitle <- c("Upper thermal limit (°C)" = "MaxCtmax", "Lower thermal limit (°C)" = "MinCtmin", "Seasonality (°C)" = "Seasonality", "Latitude (°)" = "Latitude")

ytitle <- c("Delta upper thermal limit (°C)" = "CtmaxARR", 
            "Delta lower thermal limit (°C)" = "CtminARR", 
            "Seasonality (°C)" = "Seasonality", 
            "Upper thermal limit (°C)" = "MaxCtmax", 
            "Thermal tolerance range (°C)" = "TTR")

beetleCols <- c("Species", "Mass", "UTL14.5", 
                "Mean upper thermal limit (°C)" = "UTL20.5", 
                "Delta upper thermal limit (°C)" = "DeltaUTL", 
                "LTL14.5", 
                "Mean lower thermal limit (°C)" = "LTL20.5", 
                "Delta lower thermal limit (°C)" = "DeltaLTL", 
                "Thermal Tolerance Range (°C)" = "TTR", 
                "SLatLimit", "NLatLimit", 
                "Latitudinal range extent (°)" = "LRE", 
                "Latitudinal range center point (°)" = "LRCP", 
                "MeanUTL",
                "MeanLTL")

htmls <- c(expression(Delta))
h0 <- c("TTR vs LRCP", "Mean UTL vs LRCP")
h1 <- c(HTML("&Delta;UTL vs LRCP"), HTML("&Delta;LTL vs LRCP"))
h2 <- c(HTML("&Delta;UTL vs TTR"), HTML("&Delta;UTL vs mean UTL"), HTML("&Delta;LTL vs mean LTL"))

shinyServer <- function(input, output, session) {
  

  output$plotOptions <- renderUI({
    validate(
      need(input$hypothesis, "")
    )
    if (input$hypothesis == 0) {
      radioGroupButtons("plots", "", choices = c(h0[1]), selected = h0[1], status = "success", size = "xs")
    } else if (input$hypothesis == 1) {
      radioGroupButtons("plots", "", choices = c(h1[1], h1[2]), selected = h1[1], status = "success", size = "xs")
    } else {
      radioGroupButtons("plots", "", choices = c(h2[1], h2[2], h2[3]), selected = h2[1], status = "success", size = "xs")
      
    }
  })
  
  xvar <- reactive({
    validate(
      need(input$plots, "")
    )
    if (input$hypothesis == 0) {
      if (input$plots == h0[1]) {
        xvar = "LRCP"
      } else {
        xvar = "LRE"
      }
    } else if (input$hypothesis == 1) {
      xvar = "LRCP"
    } else {
      if(input$plots == h2[1]) {
        xvar = "TTR"
      } else if (input$plots == h2[2]) {
        xvar = "UTL20.5"
      } else {
        xvar = "LTL20.5"
      }
    }
    xvar
  })
  
  yvar <- reactive({
    if (input$hypothesis == 0) {
      yvar = "TTR"
    } else if (input$hypothesis == 1) {
      if (input$plots == h1[1]) {
        yvar = "DeltaUTL"
      } else {
        yvar = "DeltaLTL"
      }
    } else {
      if(input$plots == h2[3]) {
        yvar = "DeltaLTL"
      } else {
        yvar = "DeltaUTL"
      }
    }
  })

  output$beetles <- renderPlotly({
    validate(
      need(input$plots, "")
    )
    xvar <- xvar()
    yvar <- yvar()
    p <- plot_ly() %>%
      add_trace(x = beetles[, xvar], y = beetles[, yvar], name = "Data points", type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = names(beetleCols)[which(beetleCols %in% xvar)]),
             yaxis = list(title = names(beetleCols)[which(beetleCols %in% yvar)]))
    
    fit <- lm(beetles[, yvar] ~ beetles[, xvar])
    linetype <- ifelse(signif(summary(fit)$coefficients[2,4], digits = 2) < 0.05, "solid", "dash")
    p <- p %>% add_lines(x = ~beetles[, xvar], y = ~fitted(fit), name = "Trendline", line = list(color = "green", dash = linetype))

    p
  })
  
  output$beetlestats <- renderText({

    xvar <- beetles[, xvar()]
    yvar <- beetles[, yvar()]
    
    fit <- lm(yvar~xvar)
    pval <- signif(summary(fit)$coefficients[2,4], digits = 2)
    
    if (!is.na(pval) & pval < 0.05) {
      pval <- paste("<b style = 'color:red;'>", pval, "</b>")
    }
    
    HTML("<b>Stats</b>",
         "<br>p-value:", pval,
         "<br>R<sup>2</sup>:", signif(summary(fit)$r.squared, digits = 2))
  })
  
  

  filter <- reactive({
    if (input$taxa != "All") {
      data <- dplyr::filter(data, Group %in% input$taxa)
    }
    data[, c(input$independent ,"Habitat", input$dependent)] %>% 
      na.omit()
  })
  
  output$habitatInput <- renderUI({
    choices <- unname(habitats[unique(filter()[, "Habitat"])])
    
    pickerInput("habitat", "Select habitat", choices = choices, multiple = TRUE, selected = habitats,
                options = list(style = "btn-success"))
  })
  
  refilter <- reactive({
    dplyr::filter(filter(), Habitat %in% names(habitats)[which(habitats %in% input$habitat)])
  })
  
  output$plot1 <- renderPlotly({
    validate(
      need(input$taxa, "Select taxa"),
      need(input$habitat, "Select habitat")
    )
    df <- refilter()
    xvar <- df[, input$independent]
    yvar <- df[, input$dependent]
    
        
    p <- plot_ly(x = ~xvar) %>%
      add_trace(y = ~yvar, name = "Data points", type = "scatter", mode = "markers") %>%
      layout(xaxis = list(title = names(xtitle)[which(xtitle %in% input$independent)]),
             yaxis = list(title = names(ytitle)[which(ytitle %in% input$dependent)]))
    
    
    if (input$trend) {
      fit <- lm(yvar~xvar)
      linetype <- ifelse(signif(summary(fit)$coefficients[2,4], digits = 2) < 0.05, "solid", "dash")
      
      p <- p %>% add_lines(y = ~fitted(fit), name = "Trendline", mode = "lines", line = list(color = "green", dash = linetype))
    }
    
    p
  })
  
  output$stats <- renderText({
    validate(
      need(input$taxa, ""),
      need(input$habitat, ""),
      need(input$trend, "")
    )
    df <- refilter()
    
    xvar <- df[, input$independent]
    yvar <- df[, input$dependent]
    
    fit <- lm(yvar~xvar)
    pval <- signif(summary(fit)$coefficients[2,4], digits = 2)
    
    if (!is.na(pval) & pval < 0.05) {
      pval <- paste("<b style = 'color:red;'>", pval, "</b>")
    }
    
    HTML("<b>Trend line analysis</b>",
         "<br>p-value:", pval,
         "<br>R<sup>2</sup>:", signif(summary(fit)$r.squared, digits = 2))
  })
  

}

