library(shiny)
library(shinythemes)
library(leaflet)

fish_tracking<-read.csv("data/fish_tracking.csv", header= TRUE)


# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("cosmo"),
   
   # Application title
   titlePanel("Fish Locations"),
   
   p("Tracking the movements of a unique fish"),
   
   # Sidebar with radio buttton
   sidebarPanel(
   radioButtons("fish", label = h3("Select Unique Fish"),
                choices = list("Fish 1" = 1, "Fish 2" = 2, "Fish 3" = 3), 
                selected = 1)),

      
      # Show a map of the generated distribution
      mainPanel(
        leafletOutput ("fishmap", height = 600)
      )
   )


# Define server logic required to draw a histogram
server <- function(input, output) {

   
  output$fishmap <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Stamen.Terrain")%>%
      setView(-83.09, 29.25, 12)
  })
  
  observe({
    
    fish<- fish_tracking %>% 
      filter( fish== input$fish) %>% 
      select (fish, pass, long_dd, lat_dd)
    
    fishicon <- makeIcon(
      iconUrl = "./icon/fish_icon.png",
      iconWidth = 50, iconHeight = 35)
  
    
    leafletProxy("fishmap") %>% 
      clearMarkers() %>% 
      addMarkers(lng = fish$long_dd,
                       lat = fish$lat_dd,
                       label = paste0("Pass ", fish$pass),
                       labelOptions = labelOptions(noHide = T, direction="bottom"),
                       popup = paste0("Latitude ",fish$lat_dd, " Longitude ", fish$long_dd),
                       icon= fishicon)
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

