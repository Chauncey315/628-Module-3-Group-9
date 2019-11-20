import os
import numpy as np 
import pandas as pd 
import json

# set running directory
# os.chdir()

# load dat
users = pd.read_csv("./data/data_asianrestaurant/user/user_tor_restaurant_noelite.csv")

# build a dictionary about user mapping to friends
friend_dic = users.set_index('user_id').to_dict('dict')['friends']
for key in friend_dic:
    friend_dic[key] = list(friend_dic[key].split(', '))

# dict saved to json
with open("./data/network/u2u.json", 'w') as file:
    file.writelines(json.dumps(friend_dic)+'\n')
