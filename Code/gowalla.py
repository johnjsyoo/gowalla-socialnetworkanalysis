__author__ = 'John'

####################
## IMPORTING DATA ##
####################

import networkx as nx
import pandas as pd
import matplotlib.pyplot as plt
import time

# Read the data
gowalla_edges = pd.read_csv("gowalla_edges.txt", sep="\t", header = None)

# Add a value of one to each node so we start at 1
gowalla_edges = gowalla_edges + 1

# Convert the pandas DF into a networkx graph object
friendship_graph = nx.from_pandas_dataframe(gowalla_edges,0,1)
friendship_graph.to_undirected()

# Export the graph for use in Gephi
nx.write_graphml(friendship_graph, 'so.graphml')

#########################
## NETWORK LEVEL STATS ##
#########################

# Create a dictionary of eignevector centrality values for each node
# Return the eigenvector dictinoary according to key value
eigenvector_dict = nx.eigenvector_centrality(friendship_graph)
eigenvector_list = sorted(eigenvector_dict.items(), key=lambda x:x[1], reverse=True)
eigenvector_list[:10]

# Degree Centrality
degree_dict = nx.degree_centrality(friendship_graph)
degree_dict
degree_list = sorted(degree_dict.items(), key=lambda x:x[1], reverse=True)
degree_list[:10]

# Katz Centrality
katz_dict = nx.katz_centrality(friendship_graph)
katz_list = sorted(katz_dict.items(), key=lambda x:x[1], reverse=True)
katz_list[:10]

# Distance
# DONT EXECUTE--TAKES TOO LONG
diameter = nx.diameter(friendship_graph)
diameter

# Center
# DONT EXECUTE--TAKES TOO LONG
center = nx.center(friendship_graph)
center

# Eccentricity
# DONT EXECUTE--TAKES TOO LONG
eccentricity = nx.eccentricity(friendship_graph)
eccentricity

# Clique
clique = nx.max_clique(friendship_graph)

threezeroeight_cliques = nx.cliques_containing_node(friendship_graph,308)
len(threezeroeight_cliques)

# Transitvity = 0.02348
transitivity = nx.transitivity(friendship_graph)

# Return density of graph
nx.density(friendship_graph)

# Return Connectivity of a graph
# DONT EXECUTE--TAKES TOO LONG
connectivity_dict = nx.node_connectivity(friendship_graph)

connectivity = nx.node_connectivity(friendship_graph)

# Shortest Path
# DONT EXECUTE--TAKES TOO LONG
shortest_path = nx.average_shortest_path_length(friendship_graph)
shortest_path = nx.average_shortest_path_length(friendship_graph)

# Closeness
# DONT EXECUTE--TAKES TOO LONG
closeness = nx.closeness_centrality(friendship_graph)

# K-Core
three_core = nx.k_core(friendship_graph, k=3)

# PageRank Centrality
page_rank = nx.pagerank(friendship_graph)
page_rank_list = sorted(page_rank.items(), key=lambda x:x[1], reverse=True)
page_rank_list[:10]

# Cliques
find_cliques = nx.find_cliques(friendship_graph)

# Clustering Coefficient
high_centrality_nodes = [308,460,2187,2010,221,528,2256,1150,506,1451]
clustering = nx.clustering(friendship_graph,nodes=high_centrality_nodes)

# Creating a subgraph of the most central node
threezeroeight_neighbors = friendship_graph.neighbors(308)
threezeroeight_subgraph = friendship_graph.subgraph(threezeroeight_neighbors)
nx.write_graphml(threezeroeight_subgraph, '308.graphml')

## Analyzing Check-in Data
gowalla_checkins = pd.read_csv("gowalla_totalCheckins.txt", sep="\t", header = None)
gowalla_checkins[0] = gowalla_checkins[0] + 1
gowalla_checkins.columns = ['user', 'time', 'lat', 'long', 'location_id']

## Grouping by check-in locations and returning the top places
grouped_checkins = gowalla_checkins.groupby('location_id')
location_counts = grouped_checkins._count().sort(columns='user', ascending=False)
location_counts[:10]
top_100_locations = list(location_counts.index[:100])

## Grouping by users and returning the top places
grouped_user_checkins = gowalla_checkins.groupby('user')
user_checkin_counts = grouped_user_checkins._count().sort(columns='location_id', ascending=False)
user_checkin_counts[:100]
list(user_checkin_counts.index[:100])

## Getting Lat and Long of Top Locations
gowalla_checkins[gowalla_checkins['location_id'].isin(top_100_locations)]