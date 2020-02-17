library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)


fish_weight<-read.csv("data/fish_weight.csv", header= TRUE)


ui <- fluidPage(theme = shinytheme("yeti"),
   

   titlePanel("Fish Models"),
  
   sidebarLayout(
      sidebarPanel(
        selectInput("fish", label = h3("Select Fish Species"), 
                    choices=c(as.character(fish_weight$fish)), selected = 1),
    
             checkboxGroupInput("model", h3("Select model"), 
                         choices = list("Linear Model" = 1, 
                                        "Density" = 2),
                                        selected = 1)),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("fishweight")
      )
   )
)
# Define server logic required to draw a histogram
server <- function(input, output) { 
   
   output$fishweight <- renderPlot({
     
    if (input$model == 1 ) {
    
       fish_weight <- fish_weight %>% 
       filter(fish== input$fish) %>% 
       select(fish,age,weight)
     
     ggplot(data= fish_weight, aes(y=weight, x= age)) +
       geom_point(size=3)+
       geom_smooth(method = lm, se = FALSE) +
       xlab("Age")+
       ylab("Weight")+
       theme_classic()
     
    } else if (input$model==2 ) {
      
      fish_weight <- fish_weight %>% 
        filter(fish== input$fish) %>% 
        select(fish,age,weight)
      
      ggplot(data= fish_weight, aes(x=weight)) +
        geom_density () +
        xlab("Weight")+
        ylab("Probability")+ 
        theme_classic()
      
    }
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

