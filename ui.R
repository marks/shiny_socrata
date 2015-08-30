library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),
	tags$head(includeScript("google-analytics.js")),
	headerPanel("Analyze CSV Data"),
	sidebarPanel(
		h4("Setup"),
		textInput("url", "URL to CSV", "http://data.cms.gov/resource/kcsi-wmjs.csv"),
		uiOutput('chartOptions'),
		hr(),
		HTML(
			"<span class='help-block'>",
			"Psst: you can pass the following url parameters: ",
			"<span style='font-family: monospace;'>url</span>,",
			"<span style='font-family: monospace;'>xAxis</span>, and ",
			"<span style='font-family: monospace;'>yAxis</span>.",
			"<span style='font-family: monospace;'>colorBy</span>.",
			"</span>"
		),
		h4("Try these URLs:"),
		helpText(HTML("<ul>
			<li>data.cms.gov 2014 ACO performance data: ACO-1 by Track: <a href='?url=http://data.cms.gov/resource/kcsi-wmjs.csv&xAxis=track&yAxis=aco_1&colorBy=participate_in_advance_payment_model'>?url=http://data.cms.gov/resource/kcsi-wmjs.csv&xAxis=track&yAxis=aco_1& colorBy=participate_in_advance_payment_model</a></li>
			<li>data.medicare.gov State Hospital Acquired Infection (HAI) scores: <a href='?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score'>?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score</a></li>
			<li>data.cityofchicago.org Affordable Housing capacity by type: <a href='?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units'>?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units</a></li>
			</ul>"))
	),
	mainPanel(
		fluidRow(
			column(width = 6,
				h3("Scatter plot"),
	      plotOutput("scatterplot", height = 350,
	        dblclick = "scatterplot_dblclick",
	        brush = brushOpts(
	          id = "scatterplot_brush",
	          resetOnNew = TRUE
	        )
	      )
			),
			column(width = 6,
				h3("Box plot"),
	      plotOutput("boxplot", height = 350,
	        dblclick = "boxplot_dblclick",
	        brush = brushOpts(
	          id = "boxplot_brush",
	          resetOnNew = TRUE
	        )
	      )
			)
		),
		helpText("You can click, drag, and double click to zoom into the scatter plot. Double click to zoom back out to original extent."),
		hr(),
		fluidRow(
			column(width = 6,
				h4("X Axis Variable Summary"),
				verbatimTextOutput("xAxisSummary")
			),
			column(width = 6,
				h4("Y Axis Variable Summary"),
				verbatimTextOutput("yAxisSummary")
			)
		),
		hr(),
		h2("Data Sample"),
		helpText("Only the first twenty rows are shown below"),
		tableOutput('table')
	)
))



