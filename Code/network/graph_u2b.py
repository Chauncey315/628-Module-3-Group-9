import os
import json
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
# import networkx as nx

# set running directory
# os.chdir()

# read u2u.json
with open("./data/network/u2u.json", 'r') as f:
    u2u_json = json.load(fp=f)

# read u2b.json
with open(".data/network/u2b.json", 'r') as f:
    u2b_json = json.load(fp=f)

# node list
u2u_node = []
for key in u2u_json.keys():
    u2u_node.append(key)
    # for i in u2u_json[key]:
    #     u2u_node.append(i)

for key in u2b_json.keys():
    u2u_node.append(key)

# edge list
u2u_edge = []
for key in u2u_json.keys():
    for i in u2u_json[key]:
        u2u_edge.append((key, i))

for key in u2b_json.keys():
    for i in u2b_json[key]:
        u2u_edge.append((key, i))

for i in range(len(u2u_edge)):
    u2u_edge[i] = tuple(sorted(u2u_edge[i]))
u2u_edge = list(set(u2u_edge))

# define NDAG
u2u_G = nx.Graph()
u2u_G.add_nodes_from(u2u_node)
u2u_G.add_edges_from(u2u_edge)
#nx.draw(u2u_G,pos = nx.random_layout(u2u_G), node_color = 'b',edge_color = 'r',with_labels = False, font_size =18,node_size =20)
u2u_pagerank = pd.Series(nx.pagerank_scipy(u2u_G))
u2u_pagerank_dic = u2u_pagerank.to_dict()

with open("./data/data_asianrestaurant/business/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

restaurant_list = list(restaurant_dic.keys())

u2b_pagerank_dic = {}
for key in u2u_pagerank_dic.keys():
    if key in restaurant_list:
        u2b_pagerank_dic[key] = u2u_pagerank_dic[key]
# len(u2b_pagerank_dic.keys())

with open(".data/network/u2b_pagerank.json", 'w') as file:
    file.writelines(json.dumps(u2b_pagerank_dic)+'\n')
