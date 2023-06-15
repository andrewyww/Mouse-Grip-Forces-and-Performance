library(tidyverse)
library(sf)
library(jpeg)

# Import force data
forces <- read.csv("forces.csv") %>%
  mutate(across(participant:trial, factor),
         grip = relevel(grip, "fingertip", "claw", "palm")) %>%
  select(participant:F5) %>%
  rename(lside = F1, lclick = F2, rclick = F3, rside = F4, body = F5) %>%
  pivot_longer(cols = lside:body, names_to = "section", values_to = "force")

# Import shapefile and take note of bounding box values
shapefile <- sf::st_read("./mouse_shapefile/mouse_shapefile.shp") 

# Import image
img <- jpeg::readJPEG("./images/mouse.jpg")

# Summarize force data per section by trial
df_trial <- forces %>% 
  group_by(participant, grip, trial, section) %>%
  summarise(median = median(force),
            max = max(force))

df <- df_trial %>% 
  group_by(participant, grip, section) %>%
  summarise(median = mean(median),
            max = mean(max))

# Combine force data with shapefile
combdf <- merge(df, shapefile)

#### Plot fingertip grip ####

# Median
ggplot(data = combdf %>% filter(grip == "fingertip"), aes(fill = median)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,2)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/fingertip_median.png", dpi = 1200)

# Max
ggplot(data = combdf %>% filter(grip == "fingertip"), aes(fill = max)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,3)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/fingertip_max.png", dpi = 1200)

#### Plot claw grip ####

# Median
ggplot(data = combdf %>% filter(grip == "claw"), aes(fill = median)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,2)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/claw_median.png", dpi = 1200)

# Max
ggplot(data = combdf %>% filter(grip == "claw"), aes(fill = max)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,3)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/claw_max.png", dpi = 1200)

#### Plot palm grip ####

# Median
ggplot(data = combdf %>% filter(grip == "palm"), aes(fill = median)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,2)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/palm_median.png", dpi = 1200)

# Max
ggplot(data = combdf %>% filter(grip == "palm"), aes(fill = max)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,3)) + 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

ggsave("./plots/palm_max.png", dpi = 1200)

#### Facet graphs ####

# Facet median
ggplot(data = combdf, aes(fill = median)) + 
  facet_wrap(~grip) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,2)) + 
  theme(# hide axis text, ticks, and plot background
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank()) + 
  labs(fill = "Force (N)")

# Facet max
ggplot(data = combdf, aes(fill = max)) + 
  facet_wrap(~grip) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,3)) + 
  theme(# hide axis text, ticks, and plot background
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank()) + 
  labs(fill = "Force (N)")

# Facet both
grip.labs <- c("Fingertip", "Claw", "Palm")
names(grip.labs) <- c("fingertip", "claw", "palm")
stat.labs <- c("Max", "Median")
names(stat.labs) <- c("max", "median")

ggplot(data = combdf %>%
         pivot_longer(cols = c(median:max),
                      names_to = "stat", values_to = "force"),
       aes(fill = force)) + 
  facet_grid(stat~grip,
             switch = "y", # move max and median labels to left
             labeller = labeller(grip = grip.labs,
                                 stat = stat.labs)) + 
  annotation_raster(img,
                    # fill in limits below using shapefile bounding box values
                    xmin = 0.01723286, xmax = 791.1294, 
                    ymin = -1482.937, ymax = 1.263223) + 
  geom_sf(aes(geometry = geometry), lwd = NA, alpha = 0.5) +
  scale_fill_viridis_c(limits = c(0,3)) + 
  theme(# hide axis text, ticks, and plot background
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    # Facet grid labels
    strip.background = element_rect(fill = NA),
    strip.text = element_text(size = 14, face = "bold")) + 
  labs(fill = "Force (N)")

ggsave("./plots/all_mean_low.png", dpi = 600)
