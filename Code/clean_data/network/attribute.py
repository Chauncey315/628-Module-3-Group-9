import os
import numpy as np 
import pandas as pd 
import json

business = pd.read_csv("./business.csv", low_memory=False)
business.info()

with open("./data/data_asianrestaurant/business/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

restaurant_list = list(restaurant_dic.keys())

restaurant_list[0]

tor_df = business[business.business_id.isin(restaurant_list)]
tor_df.drop(columns=['address', 'attributes', 'categories', 'city', 'hours', 'name', 'postal_code', 'review_count', 'stars', 'state'], inplace=True)
tor_df = tor_df.reset_index(drop=True)
tor_df.info()
tor_df.head()

tor_df.to_csv("./data/data_asianrestaurant/business/attribute_business.csv", index=False)
