#%%
import numpy as np 
import pandas as pd 

#%%
# read csv_data
business = pd.read_csv("./data/business.csv")

#%%
# visualize
business.head()

#%%
business_clean1=business.drop(business.columns[[2,5]], axis=1)
business_clean1.head()

#%%
business_clean2=business_clean1.dropna(axis=1,how='all')

#%%
# save cleaned data
business_clean2.to_csv("./data/business_clean.csv", index=False)
business_clean2.head()

#%%
# select GTA data
selected_city = ['Toronto', 'Mississauga', 'Markham', 'North York', 'Scarborough', 'Richmond Hill', 'Vaughan']
tor_df = business_clean2[business_clean2.city.isin(selected_city)]

#%%
# drop unuse feature
tor_df = tor_df.drop(tor_df.columns[[3]], axis=1)

#%%
# save as csv
tor_df.to_csv("./data/business_toronto.csv", index=False)

#%%
type(tor_df)

#%%
#tor_df_category_split = tor_df.categories.str.split(', ')
tor_df.info()

#%%
# process the column "category"
tor_df.dropna(subset=['categories'], inplace=True)
tor_df.info()

#%%
categories_dic = tor_df.set_index('business_id').to_dict('dict')['categories']

#%%
for key in categories_dic:
    categories_dic[key] = list(categories_dic[key].split(', '))
print(categories_dic)

#%%
restaurant_dic = {}
i = 0
for key in categories_dic:
    if 'Restaurants' in categories_dic[key] or 'Food' in categories_dic[key]:
        restaurant_dic[key] = categories_dic[key]
        i += 1
print(restaurant_dic)
print(i)

#%%
# save as json
import json
with open("./data/restaurant_dic.json", 'w') as file:
    file.writelines(json.dumps(restaurant_dic)+'\n')

#%%
tor_restaurant = tor_df[tor_df.business_id.isin(restaurant_dic.keys())]

#%%
tor_restaurant.head()

#%%
# save as csv
tor_restaurant.to_csv("./data/tor_restaurant.csv", index=False)
