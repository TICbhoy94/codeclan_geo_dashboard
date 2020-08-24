# Website Regional Performance - A Data Analysis Project 
## *by Daniel McGuire, Ruaridh Hepburn & Sid Rodrigues*

![app screenshot](https://github.com/codeclan/Data-project-4/blob/master/images/Screenshot%202020-08-24%20at%2011.50.31%20(2).png)

A Shiny dashboard that shows performance of a website by location, new vs returning visitors, what sources are driving traffic with social networks being identified particularly.   

## The Business Problem


**Regional Website Performance** - CodeClan operates three campuses in three cities across Scotland:

Edinburgh
Glasgow
Inverness

Google Analytics is restrictive about how we can analyse our website performance in each of the cities for a number of reasons, including:

Limited or no ability to compare site performance two or three locations in a single view
Overview of a single city’s performance is complicated because of Google Analytics’ use of multiple small towns around a given city
In the central belt, it can be difficult to measure the effectiveness of non-digital campaign channels like radio or train station ads because we don’t always know where in particular we’re seeing a rise in user activity comes from
We would like to be able to compare high-level site performance in a defined Edinburgh and a Glasgow catchment, and also attach high level targets per catchment, including Inverness

**Data used** - We have synthesised the data using the synthpop library.  The data is saved https://github.com/codeclan/Data-project-4/tree/master/data


**Versions of packages used** - The app is written in R and uses the following libraries:

* [Shiny](https://shiny.rstudio.com/)
* [Shinydashboard](https://rstudio.github.io/shinydashboard/)
* [Lubridate](https://lubridate.tidyverse.org/)
* [Leaflet](https://rstudio.github.io/leaflet/)
* [Maps](https://cran.r-project.org/web/packages/maps/maps.pdf)
* [Shinythemes](https://rstudio.github.io/shinythemes/)
* [Dashboard Themes](https://rstudio.github.io/shinythemes/)
* [Tidyverse](https://www.tidyverse.org/)
* [Forcats](https://www.r-bloggers.com/cats-are-great-and-so-is-the-forcats-r-package/)

## Development 

**Initial Design Concept** - 

![mockup](https://github.com/codeclan/Data-project-4/blob/master/images/Example%20Dashboard.png)

**Design & Build**

First, three API calls were made of Google Analytics containing the various dimensions and metrics needed for analysis.  These were written to CSV to minimise lag when using the app (although subsequently replaced by synthetic data using [sythpop](https://cran.r-project.org/web/packages/synthpop/index.html).   

A map was added using [leaflet](https://rstudio.github.io/leaflet/) with circles showing the "catchment" areas of each campus to allow easy comparison as per the brief.  

Next [census](https://www.citypopulation.de/en/uk/scotland/) data was added to allow a comparison per 100,000 of population. 

All plots were controlled by the date slider and city radio buttons on the dashboard sidebar. 

Infoboxes from [Shiny](https://shiny.rstudio.com/) were used to show progress within the chosen date range towards the briefs secondary requirements. 

Lastly incoming traffic was tracked and plotted along with the top three social networks responsible for driving traffic towards the website.  

## Next Steps

Visualisations could be further enhanced with the addition of timeline plot to co-relate campaign/events with the performance metrics.

Heat maps could be added for realtime analytics.

Dynamic catchment area selection option could be added to allow selection of towns that form a catchment area.

Review dashboard layout and improve aesthetics by providing date granularity on the plots.
