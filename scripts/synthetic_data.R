library(synthpop)
library(e1071)
library(tidyverse)


catchment_real <- read_csv("data/catchment_data.csv")
goal_real <- read_csv("data/goal_data.csv")
social_real <- read_csv("data/social_network_data.csv")

# synthetic catchment
catchment_constant <- catchment_real %>%
  select(date, country, city, longitude, latitude, dist_edi, dist_gla, dist_inv, catchment_city, council_area, population)

# generate fake sample grouping
catchment_constant$channelGrouping <- sample(c("Paid Search", "Direct", "Organic Search", "Referral", "Social", "(Other)", "Email"), 70535, replace = TRUE)

# generate sessions data
catchment_constant$sessions <- round(runif(70535, min = 0, max = 10))

write_csv(catchment_constant, "data/catchment_syn.csv")


# synthetic goals
goal_constant <- goal_real %>%
  select(date, city, longitude, latitude, dist_edi, dist_gla, dist_inv, catchment_city)

goal_constant$sessions <- round(runif(25629, min = 0, max = 1))

goal_constant$userType <- sample(c("Returning", "New"), 25629, replace = TRUE)

goal_constant$goal2Completions <- ceiling(rnorm(25629, 0.00419, 0.07136))

goal_constant$goal9Completions <- ceiling(rnorm(25629, 0.00419, 0.07136))

goal_constant$goal11Completions <- ceiling(rnorm(25629, 0.00419, 0.07136))


write_csv(goal_constant, "data/goal_syn.csv")



# synthetic social
social_constant <- social_real %>%
  select(date, city, longitude, latitude, dist_edi, dist_gla, dist_inv, catchment_city)

social_constant$sessions <- round(runif(26901, min = 0, max = 1))

social_constant$socialNetwork <- sample(c(unique(social_real$socialNetwork)), 26901, replace = TRUE)

write_csv(social_constant, "data/social_syn.csv")




