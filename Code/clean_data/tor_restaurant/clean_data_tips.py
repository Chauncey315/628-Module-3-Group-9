#%%
import numpy as np 
import pandas as pd 
#%%
# read data
tips = pd.read_csv("./data/tip.csv")

#%%
# read restaurant json
import json
with open("./data/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

#%%
# select tips from restaurant in GTA
tips = tips[tips.business_id.isin(restaurant_dic.keys())]

#%%
# drop na
tips=tips.dropna(axis=1,how='all')

#%%
tips.head()

#%%
# process the column 'time'
tips['time'] = tips.date.str.split(' ', expand=True)[1]
tips.date = pd.to_datetime(tips.date.str.split(' ', expand=True)[0], format='%Y-%m-%d')

#%%
tips.head()

#%%
time = tips['time']
tips.drop(labels=['time'], axis=1, inplace=True)
tips.insert(4, 'time', time)
tips.head()

#%%
# save as json
tips_users = tips['user_id'].tolist()
tips_users1 = list(set(tips_users))
with open("./data/tips_users.json", 'w') as file:
    file.writelines(json.dumps(tips_users1)+'\n')

#%%
# save as csv
tips.to_csv("./data/tips_tor_restaurant.csv", index=False)
