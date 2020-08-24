library(shiny)
library(tidyverse)
library(forcats)

# load data in here

catchment <- read_csv("../data/catchment_syn.csv")
goal <- read_csv("../data/goal_syn.csv")
social_network <- read_csv("../data/social_syn.csv")


# Define server
server <- function(input, output) {

  output$logo <- renderImage({
    return(list(src = "../data/www/code_clan_dark.png",contentType = "image/jpg",alt = "Alignment",width = 230,
                height = 225))
  }, deleteFile = FALSE) 
  
  source_data <- reactive({
    catchment %>%
      filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
             date <= format(as.Date(input$dateRange[2]), "%Y-%m")) %>%
      filter(catchment_city == input$city) %>%  
      mutate(total = sum(sessions)) %>%
      group_by(channelGrouping, catchment_city, total) %>%
      summarise(source_count = sum(sessions)) %>%
      mutate(percentage = source_count / total * 100) %>%
      arrange(desc(source_count)) 
  })
  
  top_three_data <- reactive({
    social_network %>%
      filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
             date <= format(as.Date(input$dateRange[2]), "%Y-%m")) %>%
      filter(catchment_city == input$city) %>%
      filter(socialNetwork != "(not set)") %>%
      group_by(catchment_city, socialNetwork) %>%
      summarise(social_media_count = sum(sessions)) %>%
      mutate(percent = social_media_count/sum(social_media_count)*100) %>%
      arrange(desc(social_media_count)) %>%
      slice(seq_len(3)) %>%
      mutate(socialNetwork = fct_reorder(socialNetwork, social_media_count)) 
      
    
  })
  
  output$dateRangeText  <- renderText({
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
  })
  
  
  
  
  output$sessions_plot <- renderPlot({

    
    # if the user wants a bar graph 
    if(input$graph_choice == "Bar"){
    
    

    if(input$pop_choice == "Total Population"){
      catchment %>%
        group_by(date, catchment_city) %>%
        summarise(total_sessions = sum(sessions)) %>%
        filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
               date <= format(as.Date(input$dateRange[2]), "%Y-%m")) %>%
        ggplot() +
        aes(x = date, y = total_sessions, fill = catchment_city) +
        geom_col(position = "dodge") + 
        theme_minimal() +
        scale_fill_manual(values=c("#4da2cd", "#e9415e", "#e6c372")) +
        labs(
          x = "Month",
          y = "Total Number of Visitors",
          title = "Total Visitor Numbers over Catchment Area Per Month",
          fill = "" 
      ) + theme(legend.text = element_text(size=15), 
                axis.title = element_text(size = 15),
                axis.text = element_text(size = 12),
                title = element_text(size = 16))
                

    }else{
        catchment %>%
          group_by(date, catchment_city) %>%
          summarise(total_sessions_per_capita = sum(sessions)/sum(population)*100000) %>%
          filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
                 date <= format(as.Date(input$dateRange[2]), "%Y-%m"),
                 catchment_city != "Inverness") %>%
          ggplot() +
          aes(x = date, y = total_sessions_per_capita, fill = catchment_city) +
          geom_col(position = "dodge") + 
          theme_minimal() +
          scale_fill_manual(values=c("#4da2cd", "#e9415e", "#e6c372")) +
          labs(
            x = "Month",
            y = "Total Number of Visitors per 100,000",
            title = "Total Visitor Numbers over Catchment Area Per Month",
            fill = "" 
          ) + theme(legend.text = element_text(size=15), 
                    axis.title = element_text(size = 15),
                    axis.text = element_text(size = 12),
                    title = element_text(size = 16))
    }
      
    }else{
      
      # else use a line graph
      if(input$pop_choice == "Total Population"){
        
        catchment %>%
          group_by(date, catchment_city) %>%
          summarise(total_sessions = sum(sessions)) %>%
          filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
                 date <= format(as.Date(input$dateRange[2]), "%Y-%m")) %>%
          ggplot() +
          aes(x = date, y = total_sessions, colour = catchment_city) +
          geom_line(aes(group = catchment_city), size = 3) + 
          theme_minimal() +
          scale_colour_manual(values=c("#4da2cd", "#e9415e", "#e6c372")) +
          labs(
            x = "Month",
            y = "Total Number of Visitors",
            title = "Total Visitor Numbers over Catchment Area Per Month",
            fill = ""
          ) + theme(legend.text = element_text(size=15), 
                    axis.title = element_text(size = 15),
                    axis.text = element_text(size = 12),
                    title = element_text(size = 16))
                    
      }else{
        catchment %>%
          group_by(date, catchment_city) %>%
          summarise(total_sessions_per_capita = sum(sessions)/sum(population)*100000) %>%
          filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
                 date <= format(as.Date(input$dateRange[2]), "%Y-%m"),
                 catchment_city != "Inverness") %>%
          ggplot() +
          aes(x = date, y = total_sessions_per_capita, colour = catchment_city) +
          geom_line(aes(group = catchment_city), size = 3) + 
          theme_minimal() +
          scale_colour_manual(values=c("#4da2cd", "#e9415e", "#e6c372")) +
          labs(
            x = "Month",
            y = "Total Number of Vistors per 100,000",
            title = "Total Visitor Numbers over Catchment Area Per Month",
            fill = "" 
          )  + theme(legend.text = element_text(size=15), 
                     axis.title = element_text(size = 15),
                     axis.text = element_text(size = 12),
                     title = element_text(size = 16))
      }
    }
  })

  
  output$user_plot <- renderPlot({
    
    goal %>%
     filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
            date <= format(as.Date(input$dateRange[2]), "%Y-%m")) %>%
     group_by(catchment_city, userType) %>%
      summarise(return_data = sum(sessions)) %>%
     mutate(percent_compare = return_data/(sum(return_data))*100) %>%
      ggplot() +
      aes(x = catchment_city, y = return_data, fill = userType) +
      geom_text(aes(label = paste0(round(percent_compare), "%")), position = position_dodge(width = 1), vjust = -0.5, size = 5) +
      theme_minimal() +
      geom_col(position = "dodge") +
      scale_fill_manual(values = c("#4da2cd", "#e9415e")) + 
      labs(x = "", y = "Visitor Numbers", 
           title = "New vs Returning Website Visitors\n", 
           fill = "") +
      theme(legend.text = element_text(size=15), 
            axis.title = element_text(size = 15),
            axis.text = element_text(size = 12),
            title = element_text(size = 16))
   
  })
  
  

  
  # Source filter
  output$traffic_sources <- renderPlot({
      ggplot(source_data()) +
      aes(x = reorder(channelGrouping, source_count), y = source_count, fill = "#22556D") +
      geom_col() +
      theme_minimal() +
      coord_flip() +
      labs(
        x = "",
        y = " Visitor Count",
        title = "Traffic Source by City",
        fill = ""
      ) +
      scale_fill_manual(values = c("#22556D")) +
      theme(legend.position = "none",
            axis.title = element_text(size = 15),
            axis.text = element_text(size = 12),
            title = element_text(size = 16)) +
      geom_text(aes(label = paste0(round(percentage), "%")),
                size = 5, hjust = 0)
  })
  

  # Social media comparison  
  
  output$social_media_comparison <- renderPlot({ 
    ggplot(top_three_data()) + 
      aes(x = socialNetwork, y = social_media_count, fill = "#22556D") +
      geom_col() + 
      coord_flip() +
      theme_minimal() +
      theme(legend.position="none") +
      scale_fill_manual(values = c("#22556D")) +
      labs(
        title = "Top 3 Social Networks ",  y = " Visitor Count", x = ""
      ) +
      theme(legend.text = element_text(size=15), 
            axis.title = element_text(size = 15),
            axis.text = element_text(size = 12),
            title = element_text(size = 16)) +
      geom_text(aes(label = paste0(round(percent), "%")),
                size = 5, hjust = 0) 
  })
  


  output$goal_2<- renderInfoBox({
    goal_2_value <- goal %>%
      filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
             date <= format(as.Date(input$dateRange[2]), "%Y-%m"),
             catchment_city == input$city) %>%
      summarise(goal_2_target = sum(goal2Completions))
    
    infoBox(
    "Data Analysis Course", value = paste(goal_2_value, 
                            " applications "
                            ),
               icon = icon("chart-line"), color = "blue"
    )
  })
  
  output$goal_9<- renderInfoBox({
    goal_9_value <- goal %>%
      filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
             date <= format(as.Date(input$dateRange[2]), "%Y-%m"),
             catchment_city == input$city) %>%
      summarise(goal_9_target = sum(goal9Completions))
    
    infoBox(
      "PSD Course", value = paste(goal_9_value, 
                               " applications "
                               ),
      icon = icon("laptop-code"), color = "orange"
    )
  })
  
  output$goal_11<- renderInfoBox({
    goal_11_value <- goal %>%
      filter(date >= format(as.Date(input$dateRange[1]), "%Y-%m"),
             date <= format(as.Date(input$dateRange[2]), "%Y-%m"),
             catchment_city == input$city) %>%
      summarise(goal_11_target = sum(goal11Completions))
    

    infoBox(
      "FSWD Course", value = paste(goal_11_value, 
                               " applications "
                               )
      , icon = icon("file-code"), color = "olive"
    )
  })
  
  
  
  

} # Server


