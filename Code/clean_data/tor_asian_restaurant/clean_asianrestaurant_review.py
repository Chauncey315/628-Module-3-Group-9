#%%
import numpy as np 
import pandas as pd 
import json

#%%
# load review data
review = pd.read_csv('../data/review_tor_restaurant/review_tor_restaurant.csv')

#%%
# load restaurant name
with open("../new_data/business/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

#%%
# select reviews
review = review[review.business_id.isin(restaurant_dic.keys())]
review_users = review['user_id'].tolist()
review_users1 = list(set(review_users))

#%%
# save as json
with open("../new_data/review/review_users.json", 'w') as file:
    file.writelines(json.dumps(review_users1)+'\n')

#%%
# save as csv
review.to_csv("../new_data/review/review_tor_restaurant.csv", index=False)

#%%
# review.head()

#%%
# print(review_users1)
