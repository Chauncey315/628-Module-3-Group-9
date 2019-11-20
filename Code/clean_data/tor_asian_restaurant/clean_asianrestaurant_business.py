#%%
import numpy as np 
import pandas as pd 
import json

#%%
# read csv
business = pd.read_csv('../data/business_tor_restaurant/tor_restaurant.csv')

#%%
# business.head()

#%%
# selected_city = ['Toronto', 'North York', 'Scarborough']
# tor_df = business[business.city.isin(selected_city)]
# tor_df = business
# tor_df.to_csv('../new_data/tor_df.csv', index=False)

#%%
# select asian restaurant
categories_dic = tor_df.set_index('business_id').to_dict('dict')['categories']
for key in categories_dic:
    categories_dic[key] = list(categories_dic[key].split(', '))
# print(categories_dic)

selected_restaurant = ['Chinese', 'Japanese', 'Korean', 'Thai', 'Vietnamese']
restaurant_dic = {}
i = 0
for key in categories_dic:
    for kind in selected_restaurant:
        if kind in categories_dic[key]:
            restaurant_dic[key] = categories_dic[key]
            i += 1
# print(restaurant_dic)
# print(i)

#%%
# load GTA restaurant data
import json
with open("../new_data/business/restaurant_dic.json", 'w') as file:
    file.writelines(json.dumps(restaurant_dic)+'\n')

#%%
# save data
tor_restaurant = tor_df[tor_df.business_id.isin(restaurant_dic.keys())]
tor_restaurant.to_csv("../new_data/business/tor_asianrestaurant.csv", index=False)
