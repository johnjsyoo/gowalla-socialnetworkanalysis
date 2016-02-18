__author__ = 'John'

####################
## IMPORTING DATA ##
####################

import networkx as nx
import pandas as pd
import matplotlib.pyplot as plt

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
degree_list = sorted(degree_dict.items(), key=lambda x:x[1], reverse=True)
degree_list[:10]

# Katz Centrality
katz_dict = nx.katz_centrality(friendship_graph)
katz_list = sorted(katz_dict.items(), key=lambda x:x[1], reverse=True)
katz_list[:10]

# Return density of graph
nx.density(friendship_graph)

import time

start_time = time.time()

# Return Connectivity of a graph
# DONT--TAKES TOO LONG
connectivity_dict = nx.node_connectivity(friendship_graph)

connectivity = nx.node_connectivity(friendship_graph)

# Shortest Path
# DON'T TOO LONG
shortest_path = nx.average_shortest_path_length(friendship_graph)

# DON'T TOO LONG
closeness = nx.closeness_centrality(friendship_graph)

# WORKS
three_core = nx.k_core(friendship_graph, k=3)

# WORKS
page_rank = nx.pagerank(friendship_graph)

# WORKS
find_cliques = nx.find_cliques(friendship_graph)


end_time = time.time()

print("Elapsed time was %g seconds" % (end_time - start_time))

