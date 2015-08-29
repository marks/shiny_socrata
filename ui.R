shinyUI(fluidPage(
  tags$head(includeScript("google-analytics.js")),
  headerPanel(
  	h1("Analyze CSV Data"),
  	helpText("built by Mark Silverberg @ Socrata | @skram | mark.silverberg@socrata.com"),
  ),
  sidebarPanel(
    textInput("url", "URL to CSV", "http://data.cms.gov/resource/kcsi-wmjs.csv"),
    uiOutput('axisSelectors')
  ),
  mainPanel(
  	h2("Plots"),
		fluidRow(
		    column(width = 6,
		    	h3("Scatterplot"),
		      plotOutput("scatterplot", height = 300,)
		    ),
		    column(width = 6,
		    	h3("Boxplot"),
		      plotOutput("boxplot", height = 300,)
		    )
		 ),
	 h2("Data Sample"),
	 helpText("Only the first twenty rows are shown below"),
   tableOutput('table')
  )
))



