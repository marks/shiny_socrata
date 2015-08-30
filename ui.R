library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),
	tags$head(includeScript("google-analytics.js")),
	headerPanel("Analyze CSV Data"),
	sidebarPanel(
		textInput("url", "URL to CSV", "http://data.cms.gov/resource/kcsi-wmjs.csv"),
		uiOutput('axisSelectors'),
		hr(),
		helpText("Psst: you can pass the following url parameters: url, xAxis, yAxis."),
		helpText("Examples:"),
		helpText(HTML("<ul>
			<li>data.cms.gov 2014 ACO performance data: ACO-1 by Track: <a href='?url=http://data.cms.gov/resource/kcsi-wmjs.csv&xAxis=track&yAxis=aco_1'>?url=http://data.cms.gov/resource/kcsi-wmjs.csv&xAxis=track&yAxis=aco_1</a></li>
			<li>data.medicare.gov State Hospital Acquired Infection (HAI) scores: <a href='?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score'>?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score</a></li>
			<li>data.cityofchicago.org Affordable Housing capacity by type: <a href='?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units'>?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units</a></li>
			</ul>"))
	),
	mainPanel(
		h2("Plots"),
		fluidRow(
			column(width = 6,
				h3("Scatterplot"),
	      plotOutput("scatterplot", height = 350,
	        dblclick = "scatterplot_dblclick",
	        brush = brushOpts(
	          id = "scatterplot_brush",
	          resetOnNew = TRUE
	        )
	      )
			),
			column(width = 6,
				h3("Boxplot"),
	      plotOutput("boxplot", height = 350,
	        dblclick = "boxplot_dblclick",
	        brush = brushOpts(
	          id = "boxplot_brush",
	          resetOnNew = TRUE
	        )
	      )
			)
		),
		helpText("You can click, drag, and double click to zoom into the scatterplot. Double click to zoom back out to original extent."),
		hr(),
		h2("Data Sample"),
		helpText("Only the first twenty rows are shown below"),
		dataTableOutput('table')
	)
))



