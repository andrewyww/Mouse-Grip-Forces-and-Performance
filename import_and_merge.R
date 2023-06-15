## ---- import_and_merge

#### Load libraries ####
library(tidyverse)

#### Merge Fitts task ####
setwd("./data/Fitts/")
file_list <- list.files(pattern = ".sd2")

for (file in file_list) {
  
  print(file)
  temp <- read_delim(file, delim = ",", show_col_types = FALSE)
  temp$file_name <- file
  
  if (!exists("fitts")) {
    fitts <- temp
  } else {
    fitts <- rbind(fitts, temp) 
  }
  
  rm(temp)
}

# Export csv
setwd("./../..")
write.csv(fitts, file = "fitts.csv", row.names = FALSE)

#### Merge analog data ####
sampling_freq = 100

setwd("./data/Force/")
file_list <- list.files()

for (file in file_list) {
  
  print(file)
  temp <- read_delim(file, delim = ",", show_col_types = FALSE)
  temp$file_name <- file
  temp$participant <- str_split(temp$file_name, pattern = "_")[[1]][1]
  temp$condition <- str_split(temp$file_name, pattern = "_")[[1]][2]
  temp$trial <- str_split(temp$file_name, pattern = "_")[[1]][3]
  temp$time <- seq(from = 0, by = 1/sampling_freq, length.out = nrow(temp))
  temp <- na.omit(temp) # remove rows with NA (sometimes data cut off at end)
  
  if (!exists("analog")) {
    analog <- temp
  } else {
    analog <- rbind(analog, temp)
  }
  
  rm(temp)
  
}

# Export csv
setwd("./../..")
write.csv(file = "analog.csv", analog, row.names = FALSE)