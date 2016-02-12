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

## We will also convert the directed graph into an undirected graph
## First we will convert the edge list into a graph object
friendshipMatrix <- as.matrix(edgeList[,1:2])
friendship_graph_obj <- graph.edgelist(friendshipMatrix)

## Now let's reduce this object by getting rid of direction
edgeList_undirected <- as.undirected(friendship_graph_obj, mode = "collapse")

## Measuring the degree of the undirected grah and showing the top 100 values
undirected_graph <- degree(edgeList_undirected) 
head(sort(undirected_graph, decreasing=TRUE), 100)


#########################
###    STATISTICS     ###
#########################

library(igraph)

## Create a graph object so that we can run some node-level statistics
edgeListDataFrame <- graph.data.frame(edgeList)
summary(edgeListDataFrame)

## Look at in-degree and out-degree for each node
deg_full <- degree(edgeListDataFrame, mode='in') 

## Let's return only the top 100 in each vector (friendships are undirected so they should return the same values)

head(sort(deg_full, decreasing=TRUE), 100)

## Let's look at reachability -- not sure if any of this is usefull

reachability <- function(g, m) {
  reach_mat = matrix(nrow = vcount(g), 
                     ncol = vcount(g))
  for (i in 1:vcount(g)) {
    reach_mat[i,] = 0
    this_node_reach <- subcomponent(g, i, mode = m) # used "i" instead of "(i - 1)"
    
    for (j in 1:(length(this_node_reach))) {
      alter = this_node_reach[j] # removed "+ 1"
      reach_mat[i, alter] = 1
    }
  }
  return(reach_mat)
}

## Crashes
reach_full_in <- reachability(krack_full, 'in')
reach_full_in


## Check the shortest path
sp_full_in <- shortest.paths(edgeListDataFrame, mode='in')
sp_full_out <- shortest.paths(edgeListDataFrame, mode='out')
sp_full_in


## Finding Communities using the 'fastgreedy.community' algorithm
communities_friends <- fastgreedy.community(edgeList_undirected)

res_g <- simplify(contract(edgeList_undirected, membership(communities_friends))) 


####################
######GRAPHING######
####################



library(igraph)

set.seed(123)
g <- barabasi.game(1000) %>%
  as.undirected()












library(igraph)

friendshipMatrix <- as.matrix(edgeList[,1:2])
friendship_graph_obj <- graph.edgelist(friendshipMatrix)

E(g)$arrow.size <- .50

## This plot takes a very long time -- DO NOT EXECUTE
plot(g, layout = layout.fruchterman.reingold, 
     edge.curved = TRUE)
