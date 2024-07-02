#### Script for mapping the traps ####
library(sf)
library(tmap)
library(tmaptools)
library(lubridate)
library(magick)

source("src/load-data.R")

# a bit of basic rearranging of things
d.trap <- d %>% mutate(day = day(date), month = month(date), year = year(date)) %>%
  mutate(cat = species == "Cat") %>%
  filter(!is.na(Lat)) %>%
  group_by(year, month) %>%
  mutate(agg.date = ymd(paste(year, month, "01", sep = "-"))) 

d.trap$cat[is.na(d.trap$cat)] <- FALSE

# make the data spatial
d.trap <-  d.trap %>% 
  st_as_sf(coords = c("Long", "Lat")) %>%
  st_set_crs(4326)

# get a base map
bm <- read_osm(
  d.trap,
  type = "osm", # for satellite image, "esri-imagery",
 # zoom = 10,
  ext = 1.3
)

# make a map of all traps
make_map <- function(data, filename = "out/static-map.png", basemap = bm, title.text = "Traps on the Dudley") {
  p <- tm_shape(basemap,
                unit = "km") +
    tm_rgb() +
    tm_shape(data) +
    tm_dots(size = 0.2,
            col = "red") +
    tm_add_legend(type = "symbol", title = title.text)
  
  tmap_save(p, filename = filename)
}

make_map(d.trap)

# make a temporal series of maps
plot.months <- unique(d.trap$agg.date)

for (mm in 1: length(plot.months)){
  temp <- filter(d.trap, agg.date == plot.months[mm])
  make_map(temp, 
           filename = file.path("out", "dynamic-map", paste0(plot.months[mm],".png")),
           title.text = plot.months[mm])
}

fpath <- "out/dynamic-map/"
flist <- list.files(path = fpath, pattern = ".png", full.names = TRUE)
images <- image_read(flist)
animation <- image_animate(images, fps = 0.5)
image_write(animation, path = paste0("out/dynamic-map/traps-over-time", ".gif"))

file.remove(flist)
