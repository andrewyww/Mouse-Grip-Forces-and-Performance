library(tidyverse)
library(sf)
library(jpeg)
# library(ggpubr)

setwd("D:/Documents/ReproRehab/Project")

#import shapefile and take note of bounding box values
test <- sf::st_read("./mouse_shapefile/mouse_shapefile.shp") 

#import image
img <- jpeg::readJPEG("mouse.jpg")


# create test data and combine with shapefile
testdata <- data.frame("section" = c("lclick", "rclick", "lside", "rside", "body"),
                       "force" = c(2,2,1,1,0.5))
combdf <- merge(test, testdata)

# plot data
ggplot(data = combdf, aes(fill = force)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(alpha = 0.5) +
  scale_fill_viridis_c() + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank())

# export plot
ggsave("test.png", dpi = 1200)
