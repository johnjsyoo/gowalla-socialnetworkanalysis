library(readr)

setwd("~/GitHub/gowalla-socialnetworkanalysis")

# Loading Data -- Make sure file names match and the working directory is set

edgeList <- read_delim("gowalla_edges.txt", col_names = FALSE)

fullData <- read.delim("gowalla_totalCheckins.txt", sep = "\t")


fullData <- read.table("gowalla_totalCheckins.txt", sep = "\t")

edgeListCols <- c("Node_1",
                  "Node_2")

fullDataCols <- c("user",
                  "check-in_time",	
                  "latitude",
                  "longitude",
                  "location id")

colnames(edgeList) <- edgeListCols
colnames(fullData) <- fullDataCols
