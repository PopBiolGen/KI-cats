library(readxl)
library(dplyr)
library(lubridate)

d <- read.csv(file = "dat/Trapping Data For Ben (June 30 2024).csv")

d <- d %>% as_tibble() %>%
          select(Dataset, date, Site.ID, Lat, Long, 
                  Work.Zone, Trap.Type, trap_status_at_arrival, species, 
                  species_other) %>%
          mutate(date = dmy(date)) %>%
          mutate(Lat = as.numeric(Lat), Long = as.numeric(Long))

