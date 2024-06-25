library(readxl)
library(dplyr)

d <- read_excel("dat/Monthly CPUE (All data until June2024).xlsx", 
              sheet = "Dudley Trap Nights")
names(d) <- make.names(names(d))
d <- d %>% select(Dataset, date, site_id_cage_trap_inspection, Lat, Long, 
                  Work.Zone, Trap.Type, trap_status_at_arrival, species, 
                  species_other)
