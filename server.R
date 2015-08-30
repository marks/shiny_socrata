library(shiny)
library(ggplot2)

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

  output$axisSelectors <- renderUI({
    if(is.null(input$url)){}
    else {
      list(
        selectizeInput("xAxisSelector", "X Axis Variable:",
            colnames(datasetInput())),
        selectizeInput("yAxisSelector", "Y Axis Variable:",
            colnames(datasetInput()))
      )      
    }
  })

  output$table <- renderTable({
    head(datasetInput(),n=20)
  })

  output$scatterplot <- renderPlot({
    x <- as.symbol(input$xAxisSelector)
    y <- as.symbol(input$yAxisSelector)
    qplot(eval(x),eval(y),data=datasetInput(), xlab=x,ylab=y)
  })

  output$boxplot <- renderPlot({
    x <- as.symbol(input$xAxisSelector)
    y <- as.symbol(input$yAxisSelector)
    boxplot(eval(y)~eval(x),data=datasetInput(), xlab=input$xAxisSelector,ylab=input$yAxisSelector)
  })

})


