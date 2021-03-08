library(rsconnect)
library(gapminder)
library(shiny)
library(here)
library(tidyverse)
PATH <- here("yolo.csv")

df.accomodations <- read_csv(PATH) %>% 
  mutate(available_start = as.Date(available_start, "%m/%d/%Y"), 
         available_end = as.Date(available_end, "%m/%d/%Y"))

ui <- fluidPage(
  h1("Yolo"),
  h2(paste0("last update:", format(Sys.time(), "%a %b %d %X %Y"))), 
  selectInput("housing_name", "housing_name",
              choices = c("All", df.accomodations$housing_name)),
  

  checkboxGroupInput("dryerSelect", 
                            h3("dryer"), 
                            choices = unique(df.accomodations$dryer),
                            selected = df.accomodations$dryer
         ),
  

  dateRangeInput("date_range", h3("Starting Date Range")),
  
  numericInput("people_count", 
               h3("Number Of People"), 
               value = 1),
    # Replace the tableOutput() with DT's version
  DT::dataTableOutput("table")
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
    
    # filter by person number
    data <- data %>% 
      filter(max_n > input$people_count | max_n == input$people_count) %>% 
      mutate(
        price_per_person = price_month / input$people_count
      ) %>% 
      relocate(c(price_per_person, price_month), .after = "housing_name")
    
    # filter by date 
    data <- data %>% 
      filter(available_start >= input$date_range[1] & 
             available_start <= input$date_range[2])  
    #         available_end <= input$date_range[2] &
    #         available_end >= input$date_range[1])
    
    
    data 
  })
  
  # Replace the renderTable() with DT's version
  output$table <- DT::renderDataTable({
    data <- updated_data()
    data
  })
  
}

shinyApp(ui, server)