# load libraries
library(tidyverse)

# import analog and calibration data
cal <- read.csv("calibration.csv")
analog <- read.csv("analog.csv")

# create 7th column "valuelessthancal"
cal$valuelessthancal <- FALSE

# create empty columns to store converted values
analog$F1_mass <- 0
analog$F2_mass <- 0
analog$F3_mass <- 0
analog$F4_mass <- 0
analog$F5_mass <- 0

# set up progress bar
pb <- txtProgressBar(min = 0,      # Minimum value of the progress bar
                     max = nrow(analog), # Maximum value of the progress bar
                     style = 3,    # Progress bar style (also available style = 1 and style = 2)
                     width = 50,   # Progress bar width. Defaults to getOption("width")
                     char = "=")   # Character used to create the bar


# convert analog readings to mass

for (sensor in 1:5) {
  
print(paste("Converting", colnames(analog)[sensor], "from analog to mass", sep = " "))
  
  for (reading in 1:nrow(analog)) {
    
    # TRUE if calibration value is less than recorded value
    cal[,7] <- ifelse(analog[reading,sensor] < cal[,1+sensor], TRUE, FALSE)
    # store analog1, analog2, mass1, and mass2 values based on values on either side of reading
    analog1 <- tail(subset(cal, valuelessthancal == FALSE), n = 1)[,1+sensor]
    analog2 <- head(subset(cal, valuelessthancal == TRUE), n = 1)[,1+sensor]
    mass1 <- tail(subset(cal, valuelessthancal == FALSE), n = 1)$Mass
    mass2 <- head(subset(cal, valuelessthancal == TRUE), n = 1)$Mass
    # calculate mass using linear interpolation
    analog[reading,10+sensor] = (mass2-mass1)/(analog2-analog1)*(analog[reading,sensor]-analog1) + mass1
    
    setTxtProgressBar(pb, reading)
    
  }
  
}

# rename columns, convert mass to force, create grip column, rearrange columns
analog %<>%
  rename(F1_analog = F1,
         F2_analog = F2,
         F3_analog = F3,
         F4_analog = F4,
         F5_analog = F5) %>%
  mutate(F1 = F1_mass/1000 * 9.81,
         F2 = F2_mass/1000 * 9.81,
         F3 = F3_mass/1000 * 9.81,
         F4 = F4_mass/1000 * 9.81,
         F5 = F5_mass/1000 * 9.81,
         # create column "grip" from "condition"
         grip = case_when(condition == "C01" ~ "fingertip",
                          condition == "C02" ~ "claw",
                          condition == "C03" ~ "palm")) %>%
  select(file_name:condition, grip, trial:time,
         F1:F5, F1_analog:F5_analog, F1_mass:F5_mass)

# export force data
write.csv(file = "forces.csv", analog, row.names = FALSE)