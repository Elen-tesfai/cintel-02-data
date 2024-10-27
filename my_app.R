library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(palmerpenguins)

# Load the penguins dataset
data("penguins")

ui <- dashboardPage(
  dashboardHeader(title = "Elen's Penguins Dataset Exploration"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Table", tabName = "data_table", icon = icon("table")),
      menuItem("Data Grid", tabName = "data_grid", icon = icon("th")),
      menuItem("Charts", tabName = "charts", icon = icon("chart-bar"))
    ),
    selectInput("feature", "Select Feature:", 
                choices = names(penguins)[!(names(penguins) %in% c("species"))],
                selected = "bill_length_mm")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data_table",
              h2("Data Table"),
              dataTableOutput("penguins_table")),
      tabItem(tabName = "data_grid",
              h2("Data Grid"),
              DT::dataTableOutput("penguins_grid")),
      tabItem(tabName = "charts",
              h2("Charts"),
              plotlyOutput("histogram"))
    )
  )
)

server <- function(input, output) {
  
  output$penguins_table <- renderDataTable({
    datatable(penguins)
  })
  
  output$penguins_grid <- DT::renderDataTable({
    datatable(penguins, options = list(pageLength = 5, autoWidth = TRUE))
  })
  
  output$histogram <- renderPlotly({
    p <- plot_ly(penguins, x = ~get(input$feature), type = "histogram", color = ~species) %>%
      layout(title = paste("Distribution of", input$feature),
             xaxis = list(title = input$feature),
             yaxis = list(title = "Count"))
    p
  })
}

shinyApp(ui = ui, server = server)
