library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),
	tags$head(includeScript("google-analytics.js")),
	tags$title("R/Shiny w/ Open Data"),
	
	column(width = 12,
		h1("Analyze CSV Data"),
		HTML(
			"<div class='alert alert-info'>",
	 		"<strong>Heads up!</strong> This is a <em>prototype</em> using R/Shiny and Socrata. Contact Mark Silverberg (<a href='http://twitter.com/skram' target='blank' class='alert-link'>@Skram</a> || <a href='mailto:mark.silverberg@socrata.com' class='alert-link'>mark.silverberg@socrata.com</a>) with any questions or comments.",
			"</div>"
		)
	),
	sidebarPanel(
		h4("Setup"),
		textInput("url", "URL to CSV (?url=)", "http://data.cms.gov/resource/ucce-hhpu.csv"),
		uiOutput('chartOptions'),
		br(),
		hr(),
		# HTML(
		# 	"<span class='help-block'>",
		# 	"Psst: you can pass the following url parameters: ",
		# 	"<span style='font-family: monospace;'>url</span>,",
		# 	"<span style='font-family: monospace;'>xAxis</span>, and ",
		# 	"<span style='font-family: monospace;'>yAxis</span>.",
		# 	"<span style='font-family: monospace;'>colorBy</span>.",
		# 	"</span>"
		# ),
		h4("Try these URLs:"),
		helpText(HTML("<ul>
			<li>data.cms.gov 2014 ACO performance data: ACO-1 by Track: <a href='?url=http://data.cms.gov/resource/ucce-hhpu.csv&xAxis=Participate.in.Advance.Payment.Model&yAxis=ACO.30&colorBy=Track'>?url=http://data.cms.gov/resource/ucce-hhpu.csv&xAxis=Participate.in.Advance .Payment.Model&yAxis=ACO.30&colorBy=Track</a></li>
			<li>data.medicare.gov State Hospital Acquired Infection (HAI) scores: <a href='?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score'>?url=http://data.medicare.gov/resource/k2ze-bqvw.csv&xAxis=Measure.Name&yAxis=Score</a></li>
			<li>data.cityofchicago.org Affordable Housing: <a href='?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units'>?url=http://data.cityofchicago.org/resource/s6ha-ppgi.csv&xAxis=Property.Type&yAxis=Units</a></li>
			<li>data.cityofnewyork.us Times Square Signage: <a href='?url=http://data.cityofnewyork.us/resource/6bzx-emuu.csv&xAxis=Location&yAxis=Width&colorBy=Type'>?url=http://data.cityofnewyork.us/resource/6bzx-emuu.csv&xAxis=Location&yAxis=Width&colorBy=Type</a></li>
			<li>data.kcmo.org Vacant Lots: <a href='?url=http://data.kcmo.org/resource/2dru-6tkm.csv&xAxis=Zoned.As&yAxis=Square.Footage&colorBy=Property.Class'>?url=http://data.kcmo.org/resource/2dru-6tkm.csv&xAxis=Zoned.As&yAxis=Square.Footage&colorBy=Property.Class</a></li>
			</ul>")),
		br(),
		hr(),
		h4("X Axis Variable Summary"),
		verbatimTextOutput("xAxisSummary"),
		h4("Y Axis Variable Summary"),
		verbatimTextOutput("yAxisSummary")
	),
	mainPanel(
		fluidRow(
			column(width = 6,
				h3("Scatter plot"),
	      plotOutput("scatterplot", height = 350,
	        dblclick = "scatterplot_dblclick",
	        click = "table_or_click",
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
	        click = "table_or_click",
	        brush = brushOpts(
	          id = "boxplot_brush",
	          resetOnNew = TRUE
	        )
	      )
			)
		),
		helpText("To zoom: Click, drag, and double click to zoom into the scatter plot. Double click to zoom back out to original extent."),
		helpText("To identify points: Click on or near point(s). Data table below will be populated."),
		hr(),
		h2("Data Table"),
		tableOutput('table_or_click')
	)
))



