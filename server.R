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
    } else {
      updateSelectizeInput(session, "xAxisSelector", selected = 'Track')
    }
    if(!is.null(urlQuery$yAxis)){
      updateSelectizeInput(session, "yAxisSelector", selected = urlQuery$yAxis)
    } else {
      updateSelectizeInput(session, "yAxisSelector", selected = 'ACO.1')
    }
    if(!is.null(urlQuery$colorBy)){
      updateSelectizeInput(session, "colorBySelector", selected = urlQuery$colorBy)
    } else {
      updateSelectizeInput(session, "colorBySelector", selected = 'Do not color')
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
  output$chartOptions <- renderUI({
    if(is.null(input$url)){}
    else {
      list(
        selectizeInput("xAxisSelector", "X Axis Variable (?xAxis=)",
            colnames(datasetInput())),
        selectizeInput("yAxisSelector", "Y Axis Variable (?yAxis=)",
            colnames(datasetInput())),
        selectizeInput("colorBySelector", "Color By (?colorBy=) [scatter plot only]:",
            c(c("Do not color",colnames(datasetInput()))))
      )      
    }
  })

  ## Datatable (populated with first five rows unless a graph has been clicked or hovered over)
  output$table_or_click <- renderTable({
    if(!is.null(input$table_or_click)){
      nearPoints(datasetInput(), input$table_or_click, addDist=FALSE, xvar=input$xAxisSelector, yvar=input$yAxisSelector)      
    } else {
      head(datasetInput(),n=5)  
    }    
  })

  ## Variable Summaries
  output$xAxisSummary <- renderPrint({
    summary(datasetInput()[,c(input$yAxisSelector)])
  })
  output$yAxisSummary <- renderPrint({
    summary(datasetInput()[,c(input$xAxisSelector)])
  })


  ## Interactive Scatterplot (adopted from http://shiny.rstudio.com/gallery/plot-interaction-zoom.html)
  scatterplot_ranges <- reactiveValues(scatterplot_x = NULL, scatterplot_y = NULL)
  output$scatterplot <- renderPlot({
    x <- as.symbol(input$xAxisSelector)
    y <- as.symbol(input$yAxisSelector)
    scatterplot <- ggplot(datasetInput(),aes_string(x,y), xlab=x,ylab=y) + 
      theme(legend.position="bottom") +
      geom_point() +
      coord_cartesian(xlim = scatterplot_ranges$scatterplot_x, ylim = scatterplot_ranges$scatterplot_y)
    if(input$colorBySelector != "Do not color"){
      scatterplot <- (scatterplot + aes_string(colour = input$colorBySelector))
    }
    return(scatterplot)
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
    boxplot <- ggplot(datasetInput(),aes_string(x,y), xlab=x,ylab=y) + 
      geom_boxplot() +
      coord_cartesian(xlim = boxplot_ranges$boxplot_x, ylim = boxplot_ranges$boxplot_y)
    return(boxplot)
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


