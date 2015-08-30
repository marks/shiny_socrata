library(shiny)
library(ggplot2)

options(shiny.maxRequestSize=30*1024^2) # via http://stackoverflow.com/a/18037912/252671

shinyServer(function(input, output, session) {

  datasetInput <- reactive({

    # parse URL query and adjust text fields accordingly
    urlQuery <- parseQueryString(session$clientData$url_search)
    if(!is.null(urlQuery$url)){ 
      updateTextInput(session, "url", value = urlQuery$url)
    }
    if(!is.null(urlQuery$xAxis)){
      updateSelectizeInput(session, "xAxisSelector", selected = urlQuery$xAxis)
    }
    if(!is.null(urlQuery$yAxis)){
      updateSelectizeInput(session, "yAxisSelector", selected = urlQuery$yAxis)
    }

    # read text box's URL, read, and store in data frame which is returned
    inURL <- input$url
    if(is.null(inURL)){
      return(NULL)
    } 
    else {
      data_frame <- read.csv(inURL)
    }
  })

  output$axisSelectors <- renderUI({
    if(is.null(input$url)){}
    else {
      list(
        selectizeInput("xAxisSelector", "X Axis Variable:",
            colnames(datasetInput()), selected=""),
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


