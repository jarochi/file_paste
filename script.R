

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
