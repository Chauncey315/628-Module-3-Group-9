import os
import numpy as np 
import pandas as pd 
import json

# set running directory
# os.chdir()

# load dat
df_business = pd.read_csv("./data/data_asianrestaurant/business/asian_restaurant.csv")

df_business.info()

df_business.dropna(subset=['attributes'])

# build a dictionary about user mapping to friends
# attr_dic = df_business.set_index('business_id').to_dict('dict')['attributes']

# for key in attr_dic:
#     attr_dic[key] = list(friend_dic[key].split(', '))

attr_list = df_business.attributes.to_list()
attr_list[0]
for i in attr_list:
    i = i.Replace('/', '')
