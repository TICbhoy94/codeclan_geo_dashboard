library(shiny)
library(shinydashboard)
library(lubridate)
library(leaflet)
library(maps)
library(shinythemes)
library(dashboardthemes)
library(tidyverse)

catchment <- read_csv("../data/catchment_syn.csv")

catchment_population <- catchment %>% 
  filter(!is.na(population)) %>% # data missing for Lasswade, populationg <500 so won't reall affect the comparison
  distinct(city, .keep_all = TRUE) %>%
  group_by(catchment_city) %>%
  summarise(city_popuation = sum(population))

ui <- dashboardPage(
  
  dashboardHeader(title = "Code Clan Analytics"),
  
  dashboardSidebar(
    
  
    dateRangeInput('dateRange',
                   label = 'Date range input: yyyy-mm-dd',
                   start = Sys.Date() - 90, end = Sys.Date() + 2
    ),
    
    title <- "Campus Catchment Area",
    
    map_scotland <- leaflet() %>% setView(lng = -4.20263, lat = 56.4907, zoom = 7)%>%
      addTiles %>%
      addCircles(radius = 33000, label = "Codeclan Edinburgh", 
                 lng = -3.1883, lat = 55.9533, color = "#4da2cd") %>%
      addCircles(radius = 33000, label = "Codeclan Glasgow", 
                 lng = -4.2518, lat = 55.8642, color = "#e9415e") %>%
      addCircles(radius = 50000, label = "Codeclan Inverness", 
                 lng = -4.2274, lat = 57.4778, color = "#9D761B"),
    
    
    radioButtons('city',
               'Select City',
               choices = c("Edinburgh", "Glasgow", "Inverness"),
  ),
  

  imageOutput("logo", height = 10, width = 10)
  
  
  ),

  
  dashboardBody(
    

    tags$head( 
      tags$style(HTML(".main-sidebar { font-size: 18px; }")) #change the font size to 20
    ),
    
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 15px;
      }
    '))),
    
    
   shinyDashboardThemes(
    theme = "grey_dark"
    ),
    

    #Section 1 - Site comparison
    fluidRow(h4(" Campus Comparison")),
    
    fluidRow(
      
    
      column(6,
             plotOutput("sessions_plot")), 

      column(6, 
             plotOutput("user_plot")
    )),

       
    fluidRow(
      br(),
      
      column(2, radioButtons("pop_choice","Total Population vs Per 100,000", 
                          choices = c("Total Population", "Per 100,000"),
                          inline = TRUE)),
      column(1,
             radioButtons("graph_choice", "Graph Format",
                          choices = c("Bar", "Line"),
                          inline = TRUE)),
      column(3,
             paste("Glasgow Catchment Population = ", catchment_population[2 ,2]), br(),
             paste("Edinburgh Catchment Population = ", catchment_population[1 ,2]), br(),
             paste("Inverness Catchment Population = ", catchment_population[3 ,2], " (removed from 100,000 graphic)")) 
             
      ),

   # Section 2 - Specific City Performance
    fluidRow(h4(" Campus Focus"), 
             style='border-top: 1px solid white'),
    # goals
    fluidRow(
    
        
             
             infoBoxOutput("goal_2"),
      
             infoBoxOutput("goal_9"),
      
             infoBoxOutput("goal_11")
      
    
    ),
      

   
    fluidRow(

      column(6,
             plotOutput("traffic_sources")
      ),
        
      column(6,
             plotOutput("social_media_comparison")
      )

    
    ) 

  )
) 


