import os
import json
import matplotlib.pyplot as plt 
#import graph_tool.all as gt 

#g1 = gt.Graph()

# read top100user_dic.json
with open("./data/network/top100user_dic.json", 'r') as f:
    top100user_dic = json.load(fp=f)

with open("./data/network/u2u.json", 'r') as f:
    u2u = json.load(fp=f)

top100user_list = list(top100user_dic.keys())

top100_friend_dic = {}

for i in u2u.keys():
    if i in top100user_list:
        top100_friend_dic[i] = u2u[i]

top100_relation_tuple = []

for i in top100_friend_dic.keys():
    for j in top100_friend_dic[i]:
        top100_relation_tuple.append((i, j))

# max = 1
# for i in top100_friend_dic.keys():
#     if len(top100_friend_dic[i]) > max:
#         max = len(top100_friend_dic[i])
#         a = i 

for i in top100_relation_tuple:
    a = sorted(i)
    i = tuple(a)

temp1 = list(set(top100_relation_tuple))


node = []

for i in top100_relation_tuple:
    node.append(i[0])
    node.append(i[1])

temp2 = list(set(node))

top100user_index = {}

for i in range(len(temp2)):
    #g1.add_vertex(int(i))
    top100user_index[temp2[i]] = int(i) 

top_user_tuple_list = []

otheruser_dic = {}

c = 101
for i in u2u_tuple:
    if i[0] in top100user_index.keys():
        otheruser_dic[i[1]] = c
        top_user_tuple_list.append((c, top100user_index[i[0]]))
        #g.add_edge(c, top100user_index[i[0]])
    elif i[1] in top100user_index.keys():
        otheruser_dic[i[0]] = c
        top_user_tuple_list.append((c, top100user_index[i[1]]))
        #g.add_edge(c, top100user_index[i[1]])
    c += 1

node_list = []

for i in top_user_tuple_list:
    node_list.append(i[0])
    node_list.append(i[1])
node_list = list(set(node_list))

#gt.graph_draw(g, output="output1.png")





