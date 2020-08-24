#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#this is an app to show performance of codeclan.com by region. 

# Load Libriaries
library(shiny)


# Daniel's Update!
#Ruraidh update!





source("scripts/ui.R", local = TRUE)
source("scripts/server.R")


shinyApp(
  ui = ui,
  server = server
)

