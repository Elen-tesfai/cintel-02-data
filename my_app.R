library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(palmerpenguins)

# Load the penguins dataset
data("penguins")

ui <- dashboardPage(
  dashboardHeader(title = "Elen's Palmer Penguin Dataset Exploration"),  # Corrected title
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Table", tabName = "data_table", icon = icon("table")),
      menuItem("Data Grid", tabName = "data_grid", icon = icon("th")),
      menuItem("Charts", tabName = "charts", icon = icon("chart-bar")),
      menuItem("Scatter Plot", tabName = "scatter_plot", icon = icon("scatter-plot"))  # Added scatter plot tab
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
              plotlyOutput("histogram")),
      tabItem(tabName = "scatter_plot",
              h2("Scatter Plot"),
              plotlyOutput("scatter_plot_output"))  # Added scatter plot output
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
  
  # Add scatter plot
  output$scatter_plot_output <- renderPlotly({
    plot_ly(penguins, x = ~bill_length_mm, y = ~flipper_length_mm, color = ~species, 
            type = "scatter", mode = "markers") %>%
      layout(title = "Scatter Plot of Bill Length vs Flipper Length",
             xaxis = list(title = "Bill Length (mm)"),
             yaxis = list(title = "Flipper Length (mm)"))
  })
}

shinyApp(ui = ui, server = server)