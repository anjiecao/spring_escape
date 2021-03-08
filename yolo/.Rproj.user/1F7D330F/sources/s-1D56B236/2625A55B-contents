library(rsconnect)
library(gapminder)
library(shiny)
library(here)
library(tidyverse)
PATH <- here("yolo.csv")

df.accomodations <- read_csv(PATH)

ui <- fluidPage(
  h1("Yolo"),
  selectInput("housing_name", "housing_name",
              choices = c("All", df.accomodations$housing_name)),
  

  checkboxGroupInput("dryerSelect", 
                            h3("dryer"), 
                            choices = unique(df.accomodations$dryer),
                            selected = df.accomodations$dryer
         ),
  
  numericInput("people_count", 
               h3("Number Of People"), 
               value = 1),
    # Replace the tableOutput() with DT's version
  tableOutput("table")
)

server <- function(input, output) {
  updated_data <- reactive({
    data <- df.accomodations
    data <- data %>% 
      filter(dryer %in% input$dryerSelect)
    if (input$housing_name != "All") {
      data <- subset(
        data,
        housing_name == input$housing_name
      )
    }
    
    data <- data %>% 
      mutate(
        price_per_person = price_month / input$people_count
      ) %>% 
      relocate(c(price_per_person, price_month), .after = "housing_name")
    
    data 
  })
  
  # Replace the renderTable() with DT's version
  output$table <- renderTable({
    data <- updated_data()
    data
  })
  
}

shinyApp(ui, server)