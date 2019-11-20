import os
import json
import numpy as np 
import pandas as pd 

# set running directory
# os.chdir()

# read u2u.json
with open("./data/network/u2u.json", 'r') as f:
    u2u_json = json.load(fp=f)

# json to tuple list
u2u_tuple = []
for key in u2u_json.keys():
    for i in u2u_json[key]:
        u2u_tuple.append((key, i))

# list saved to json
# with open("./data/network/u2u_tuple.json", 'w') as file:
#     file.writelines(json.dumps(u2u_tuple)+'\n')
 