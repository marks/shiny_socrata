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

  ## Axis Selectors
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

  ## Datatable
  output$table <- renderTable({
    head(datasetInput(),n=20)
  })


  ## Interactive Scatterplot (adopted from http://shiny.rstudio.com/gallery/plot-interaction-zoom.html)
  scatterplot_ranges <- reactiveValues(scatterplot_x = NULL, scatterplot_y = NULL)
  output$scatterplot <- renderPlot({
    x <- as.symbol(input$xAxisSelector)
    y <- as.symbol(input$yAxisSelector)
    qplot(eval(x),eval(y),data=datasetInput(), xlab=x,ylab=y) + 
      geom_point() +
      coord_cartesian(xlim = scatterplot_ranges$scatterplot_x, ylim = scatterplot_ranges$scatterplot_y)
  })
  observeEvent(input$scatterplot_dblclick, {
    brush <- input$scatterplot_brush
    if (!is.null(brush)) {
      scatterplot_ranges$scatterplot_x <- c(brush$xmin, brush$xmax)
      scatterplot_ranges$scatterplot_y <- c(brush$ymin, brush$ymax)

    } else {
      scatterplot_ranges$scatterplot_x <- NULL
      scatterplot_ranges$scatterplot_y <- NULL
    }
  })

  ## Boxplot
  boxplot_ranges <- reactiveValues(boxplot_x = NULL, boxplot_y = NULL)
  output$boxplot <- renderPlot({
    x <- as.symbol(input$xAxisSelector)
    y <- as.symbol(input$yAxisSelector)
    qplot(eval(x),eval(y),data=datasetInput(), xlab=x,ylab=y) + 
      geom_boxplot() +
      coord_cartesian(xlim = boxplot_ranges$boxplot_x, ylim = boxplot_ranges$boxplot_y)
  })
  observeEvent(input$boxplot_dblclick, {
    brush <- input$boxplot_brush
    if (!is.null(brush)) {
      boxplot_ranges$boxplot_x <- c(brush$xmin, brush$xmax)
      boxplot_ranges$boxplot_y <- c(brush$ymin, brush$ymax)

    } else {
      boxplot_ranges$boxplot_x <- NULL
      boxplot_ranges$boxplot_y <- NULL
    }
  })


})


