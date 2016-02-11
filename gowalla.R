##############################
##IMPORTING DATA AND CLEANUP##
##############################

library(readr)

## Set the Working Directory for where all files are
setwd("~/github/gowalla-socialnetworkanalysis")


## Loading Data
## Make sure file names match and the correct working directory is set
edgeList <- read_tsv("gowalla_edges.txt", col_names = FALSE)
fullData <- read_tsv("gowalla_totalCheckins.txt", col_names = FALSE)


## Rename Columns
edgeListCols <- c("Node_1",
                  "Node_2")

fullDataCols <- c("user",
                  "check-in_time",	
                  "latitude",
                  "longitude",
                  "location_id")

colnames(edgeList) <- edgeListCols
colnames(fullData) <- fullDataCols


## Create separate date and time columns for hours/minutes
fullData$date <- as.Date(fullData[,'check-in_time']) 
fullData$time <- format(fullData[,'check-in_time'], "%H:%M")
fullData$hour <- format(fullData[,'check-in_time'], "%H")
fullData$minute <- format(fullData[,'check-in_time'], "%M")

## Drop the original check-in_time
fullData <- subset(fullData, select = -2)


## We need to start our node values at 1 because iGraph doesn't like zero operators
edgeList <- edgeList + 1
fullData$user <- fullData$user + 1

##########################
###      GRAPHING      ###
##########################

library(igraph)

friendshipMatrix <- as.matrix(edgeList[,1:2])
g <- graph.edgelist(friendshipMatrix)

E(g)$arrow.size <- .50

## This plot takes a very long time -- DO NOT EXECUTE
plot(g, layout = layout.fruchterman.reingold, 
     edge.curved = TRUE)
