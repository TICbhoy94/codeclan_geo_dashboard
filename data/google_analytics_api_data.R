# load libraries
library(googleAnalyticsR)
library(tidyverse)
library(lubridate)
library(geosphere)
library(gmt)
library(readxl)

# source credentials
home_location <- Sys.getenv("HOME")
credentials_location <- paste0(home_location,"/ga_credentials.R")
source(credentials_location)

options(googleAuthR.client_id = ga_client_id,
        googleAuthR.client_secret = ga_client_secret)

account_list <- ga_account_list()

# create link to the website
my_ga_id <- account_list %>%
  filter(websiteUrl == "https://codeclan.com", viewName == "All Web Site Data") %>%
  select(viewId) %>%
  pull()


# create a date range 
data_dates <- c("2019-01-01", as.character(today()))

# city centre long & lat
cc_gla <- c(55.8642, -4.2518)
cc_edi <- c(55.9533, -3.1883)
cc_inv <- c(57.4778, -4.2247)

#Call the API to access the data you require

# goal conversion data

goal_data <- google_analytics(my_ga_id, 
                date_range = data_dates, 
                metrics = c("sessions","goal1Completions", "goal2Completions", "goal9Completions", "goal11Completions", "goal13Completions", "goal17Completions"), 
                dimensions = c("month", "year", "date", "city", "campaign","latitude","longitude", "country", "userType"), max = -1)


# high level, city comparison
city_data <- google_analytics(my_ga_id, 
                 date_range = data_dates,
                 metrics = c("sessions"), 
                 dimensions = c("month", "year", "date", "city","latitude","longitude", "country", "channelGrouping", "sessionDurationBucket"), max = -1)

# top 3 social network
social_network_data <- google_analytics(my_ga_id, 
                            date_range = data_dates,
                            metrics = c("sessions"), 
                            dimensions = c("date", "country", "city", "latitude","longitude", "socialNetwork", "source"), max = -1)


city_data <- city_data %>%
 filter(country == "United Kingdom") %>%
  mutate(date = format(as.Date(date), "%Y-%m"))

goal_data <- goal_data %>%
  filter(country == "United Kingdom") %>%
  mutate(date = format(as.Date(date), "%Y-%m"))

social_network_data <- social_network_data %>%
  filter(country == "United Kingdom") %>%
  mutate(date = format(as.Date(date), "%Y-%m"))

# calculate the distance between each of the code clan campus cities and other cities
city_data <- city_data %>%
  mutate(dist_edi = geodist(55.9533, -3.1883, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_gla = geodist(55.8642, -4.2518, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_inv = geodist(57.4778, -4.2247, as.numeric(latitude), as.numeric(longitude)))

goal_data <- goal_data %>%
  mutate(dist_edi = geodist(55.9533, -3.1883, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_gla = geodist(55.8642, -4.2518, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_inv = geodist(57.4778, -4.2247, as.numeric(latitude), as.numeric(longitude)))

social_network_data <- social_network_data %>%
  mutate(dist_edi = geodist(55.9533, -3.1883, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_gla = geodist(55.8642, -4.2518, as.numeric(latitude), as.numeric(longitude)))  %>%
  mutate(dist_inv = geodist(57.4778, -4.2247, as.numeric(latitude), as.numeric(longitude)))

  

# filter by city centres within 50 km of campus city
catchment <- city_data %>%
  filter(dist_edi < 33 | dist_gla < 33 | dist_inv < 50) %>%
  mutate(catchment_city = case_when(dist_edi < 33 ~ "Edinburgh",
                                    dist_gla < 33 ~ "Glasgow",
                                    dist_inv < 50 ~ "Inverness"))
  
goal_data <- goal_data %>%
  filter(dist_edi < 33 | dist_gla < 33 | dist_inv < 50) %>%
  mutate(catchment_city = case_when(dist_edi < 33 ~ "Edinburgh",
                                      dist_gla < 33 ~ "Glasgow",
                                      dist_inv < 50 ~ "Inverness"))


social_network_data <- social_network_data %>%
  filter(dist_edi < 33 | dist_gla < 33 | dist_inv < 50) %>%
  mutate(catchment_city = case_when(dist_edi < 33 ~ "Edinburgh",
                                    dist_gla < 33 ~ "Glasgow",
                                    dist_inv < 50 ~ "Inverness"))
  

# load in scottish population data 
## https://www.citypopulation.de/en/uk/scotland/
scottish_pop <- read_xlsx("data/population.xlsx", col_types = c("text","text","numeric"))

# join to catchment area data
catchment <-
  left_join(catchment, scottish_pop, by = "city")


# convert to csv

write_csv(catchment, "data/catchment_data.csv")
write_csv(goal_data, "data/goal_data.csv")
write_csv(social_network_data, "data/social_network_data.csv")





