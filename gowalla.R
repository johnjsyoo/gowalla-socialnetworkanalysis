##############################
##IMPORTING DATA AND CLEANUP##
##############################
install.packages("readr")
library(readr)
library(igraph)

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

## We will also convert the directed graph into an undirected graph
## First we will convert the edge list into a graph object
edgeListDataFrame <- graph.data.frame(edgeList)

## Now let's reduce this object by getting rid of direction
edgeList_undirected <- as.undirected(edgeListDataFrame, mode = "collapse")

## Measuring the degree of the undirected graph and showing the top 100 values
undirected_graph <- degree(edgeList_undirected) 

## Let's return only the top 100 in each vector (friendships are undirected so they should return the same values)
degree_head <- head(sort(undirected_graph, decreasing=TRUE), 100)
degree_df <- as.data.frame(degree_head)

## Let's plot

install.packages("ggplot2")
install.packages("grid")

library(ggplot2)
library(grid)

ggplot(degree_df,aes(time)) +
  # The actual lines
  geom_line(aes(y=degree_head),size=1.6,color="#f8766d") +
  theme_bw() +
  # Set the entire chart region to a light gray color
  theme(panel.background=element_rect(fill="#F0F0F0")) +
  theme(plot.background=element_rect(fill="#F0F0F0")) +
  theme(panel.border=element_rect(colour="#F0F0F0")) +
  # Format the grid
  theme(panel.grid.major=element_line(colour="#D0D0D0",size=.75)) +
  scale_x_continuous(minor_breaks=0,breaks=seq(0,100,10),limits=c(0,100)) +
  scale_y_continuous(minor_breaks=0,breaks=seq(0,15000,3000),limits=c(0,15000)) +
  theme(axis.ticks=element_blank()) +
  # Dispose of the legend
  theme(legend.position="none") +
  # Set title and axis labels, and format these and tick marks
  ggtitle("Degree Distribution for top 100 Nodes") +
  theme(plot.title=element_text(face="bold",hjust=-.08,vjust=2,colour="#3C3C3C",size=20)) +
  ylab("Degrees") +
  xlab("Node Size Index") +
  theme(axis.text.x=element_text(size=11,colour="#535353",face="bold")) +
  theme(axis.text.y=element_text(size=11,colour="#535353",face="bold")) +
  theme(axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5)) +
  theme(axis.title.x=element_text(size=11,colour="#535353",face="bold",vjust=-.5)) +
  # Big bold line at y=0
  geom_hline(yintercept=0,size=1.2,colour="#535353") +
  # Plot margins and finally line annotations
  theme(plot.margin = unit(c(1, 1, .5, .7), "cm"))

#########################
###    COMMUNITIES     ###
#########################

## Finding Communities using the 'fastgreedy.community' algorithm 
## THIS TAKES AT LEAST 20 MINUTES TO RUN

system.time(communities_friends <- fastgreedy.community(edgeList_undirectedsumma))


## Grabbing various community statistics
membership(communities_friends[,2])
sort(sizes(communities_friends), decreasing = TRUE)
algorithm(communities_friends)
merges(communities_friends)
length(communities_friends)


res_g <- simplify(contract(edgeList_undirected, membership(communities_friends))) 


sp_full_in <- shortest.paths(edgeList_undirected, mode='in',)

####################
######GRAPHING######
####################

install.packages("tnet")
library(tnet)

## This following command will subset a 2-mode node list. One node is the user and the other is the location.
two_mode <- fullData[c(1,4)]

## We will also need to remove duplicate entries since we are not 
two_mode_unique <- two_mode[!duplicated(two_mode), ]

as.tnet(two_mode_unique, type = NULL)

clustering_local_tm(two_mode_unique)



library(igraph)

friendshipMatrix <- as.matrix(edgeList[,1:2])
friendship_graph_obj <- graph.edgelist(friendshipMatrix)

E(g)$arrow.size <- .50

## This plot takes a very long time -- DO NOT EXECUTE
plot(g, layout = layout.fruchterman.reingold, 
     edge.curved = TRUE)
