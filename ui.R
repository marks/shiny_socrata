shinyUI(fluidPage(
  tags$head(includeScript("google-analytics.js")),
  headerPanel("Read from CSV URL"),
  sidebarPanel(
    textInput("url", "URL to CSV", "http://soda.demo.socrata.com/resource/4334-bgaj.csv")
  ),
  mainPanel(
    tableOutput('table')
  )
))
