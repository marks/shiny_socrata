library(shiny)
library(RSocrata) # Stata and SPSS

options(shiny.maxRequestSize=30*1024^2) # via http://stackoverflow.com/a/18037912/252671

shinyServer(function(input, output) {

  datasetInput <- reactive({
    inURL <- input$url
    if(is.null(inURL)){
      return(NULL)
    } 
    else {
      data <- read.csv(inURL)
    }
  })

  output$table <- renderTable({
    datasetInput()
  })

})
