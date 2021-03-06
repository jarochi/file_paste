library(tidyverse)
library(gdata)
library(rowr)
library(readxl)

# fetch names lymphoX_af_15 DMSo C

files_list <-list.files(path = "data", full.names = TRUE, recursive = TRUE)

for (i in files_list) {
  x <- read.xls(i)
  name1 <- str_split(i, "/")
  name3 <- str_split(name1[[1]][4], "_")
  name2 <- name1[[1]][3]
  name1 <- name1[[1]][2]
  name3 <- name3[[1]][1]
  full_name <- paste(name1, name2, name3)
}

# read file
z <- read.xls("data/Lympho 3/After Freezing/15 DMSo C_2017-12-06_12-01-58.xls")

# delete last rows
row1 <- nrow(z)
row2 <- row1 - 3
z <- z[-c(row2:row1),]

# delete first 2 rows
z <- z[-c(1, 2),]

# select foci columns
FITC <- z$Marker..1..FITC.
APC <- z$Marker..2..APC.

# create data frame and change names
frame_data <- data.frame(FITC, APC)




### merged

files_list <- list.files(path = "data", full.names = TRUE, recursive = TRUE)
mega_frame <- data.frame()
mega_frame_FITC <- data.frame()
mega_frame_APC <- data.frame()


for (i in files_list) {
  # x <- read.xls(i)
  x <- read_excel(i)
  name <- str_split(i, "/") %>% unlist()
  name1 <- name[2] %>% strsplit(" ") %>% unlist()
  # name1 <- paste0(name1[1], name1[2])
  name1 <- paste0("L", name1[2])
  name2 <- name[3] %>% strsplit(" ") %>% unlist()
  name2 <- substr(name2, 1, 1)
  name2 <- paste0(name2[1], name2[2])
  name3 <- str_split(name[4], "_") %>% unlist()
  name3 <- name3[1] %>% strsplit(" ") %>% unlist()
  
  if(is.na(name3[3]) == TRUE){
    name3 <- paste(name3[2], name3[1], sep = "_")
  }
  else{
  name3 <- paste(name3[2], name3[3], name3[1], sep = "_")
  }
  full_name <- paste(name1, name2, name3, sep = "_")
  print(full_name)
  
  # delete last rows
  row1 <- nrow(x)
  row2 <- row1 - 3
  z <- x[-c(row2:row1),]
  
  # delete first 2 rows
  z <- z[-c(1, 2),]
  
  # select foci columns
  # FITC <- z$Marker..1..FITC.
  # APC <- z$Marker..2..APC.
  FITC <- z$`Marker: 1 (FITC)`
  APC <- z$`Marker: 2 (APC)`
  
  # create data frame and change names
  frame_data <- data.frame(FITC, APC)
  
  # change col names
  colnames(frame_data) <- c(paste(full_name, "FITC", sep = "_"), paste(full_name, "APC", sep = "_"))
  
  # all merged
  mega_frame <- cbind.fill(mega_frame, frame_data, fill = NA)
  # only FITC marker
  mega_frame_FITC <- cbind.fill(mega_frame_FITC, frame_data[1], fill = NA)
  # only APC marker
  mega_frame_APC <- cbind.fill(mega_frame_APC, frame_data[2], fill = NA)
}
nr <- nrow(mega_frame)
nr1 <- nrow(mega_frame_APC)
nr2 <- nrow(mega_frame_FITC)

foci_count <- mega_frame[-nr,-1]
write.csv2(foci_count, file = "foci_count.csv", row.names=FALSE)

foci_count_FITC <- mega_frame_FITC[-nr2,-1]
write.csv2(foci_count_FITC, file = "foci_count_FITC.csv", row.names=FALSE)

foci_count_APC <- mega_frame_APC[-nr1,-1]
write.csv2(foci_count_APC, file = "foci_count_APC.csv", row.names=FALSE)

# foci_count_APC <- read.csv2("foci_count_APC.csv")
save(foci_count_APC, file = "foci_count_APC.rda")

# foci_count_APC <- read.csv2("foci_count_FITC.csv")
save(foci_count_FITC, file = "foci_count_FITC.rda")


# foci_count_APC <- read.csv2("foci_count_merged.csv")
save(foci_count, file = "foci_count.rda")

