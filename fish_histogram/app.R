library(shiny)
library(ggplot2)
library(shinythemes)

fish_data<-read.table("data/fish_data.txt", header= TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("cerulean"),
  
  # Application title
  titlePanel("Fish Plots"),
  
  p("This is a Shiny App for fish distribution"),
  
  # Sidebar with a select input 
  sidebarPanel(
  selectInput("fish", label = h3("Select Fish Species"), 
              names(fish_data), multiple = FALSE,
              selected = "SNOOK")),

  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("fishPlot")
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$fishPlot <- renderPlot({
    
    ggplot(data = fish_data, aes_string(x=input$fish, fill= input$fish)) +
      geom_histogram(stat= "count", bins=10, aes(fill= input$fish)) +
      theme_classic() 
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

