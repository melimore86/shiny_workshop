library(shiny)
library(ggplot2)

fish_data<-read.table("data/fish_data.txt", header= TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Fish Plots"),
  
  # Sidebar with a slider input for number of bins 
  selectInput("fish", label = h3("Select Fish Species"), 
              names(fish_data), multiple = TRUE,
              selected = "AMRE"),
  
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("fishPlot")
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$fishPlot <- renderPlot({
    
    ggplot(fish_data, aes_string(x=input$fish)) +
      geom_histogram(stat= "count", bins=10) +
      theme_classic()+
      facet_grid(input$fish~.)
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

