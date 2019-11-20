#%%
import numpy as np 
import pandas as pd 
import json

#%%
# read tips data
tips = pd.read_csv('../data/tips_tor_restaurant/tips_tor_restaurant.csv')

#%%
# load restaurant data
with open("../new_data/business/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

#%%
# select tips in related restaurant
tips = tips[tips.business_id.isin(restaurant_dic.keys())]

#%%
# save as json
tips_users = tips['user_id'].tolist()
tips_users1 = list(set(tips_users))
with open("../new_data/tips/tips_users.json", 'w') as file:
    file.writelines(json.dumps(tips_users1)+'\n')

#%%
# save as csv
tips.to_csv("../new_data/tips/tips_tor_restaurant.csv", index=False)

#%%
# tips.head()

#%%
# print(tips_users1)
