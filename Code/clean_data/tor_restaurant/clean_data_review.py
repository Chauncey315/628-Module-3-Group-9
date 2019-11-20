#%%
import numpy as np 
import pandas as pd 
import json 

#%%
# read data 
# use chunk to read bigdata
review_chunks = pd.read_csv("./data/review.csv", iterator=True, low_memory=False, chunksize= 10000)
with open("./data/restaurant_dic.json", 'r') as f:
    restaurant_dic = json.load(fp=f)

#%%
review_chunks.get_chunk(5)

#%%
print(restaurant_dic)

#%%
# process the data
loop = True
chunkSize = 10000
chunks = []
while loop:
    try:
        chunk = review_chunks.get_chunk(chunkSize)
        chunk = chunk[chunk.business_id.isin(restaurant_dic.keys())]
        chunk = chunk.dropna(axis=1,how='all') 
        chunks.append(chunk)
    except StopIteration:
        loop = False
        print("Stop Iteration.")
review_clean = pd.concat(chunks, ignore_index=True)
    

#%%
review_clean.head()

#%%
review_clean1 = pd.read_csv("./data/review_tor_restaurant.csv")

#%%
# process the column 'time'
review_clean1['time'] = review_clean1.date.str.split(' ', expand=True)[1]

#%%
review_clean1.date = pd.to_datetime(review_clean1.date.str.split(' ', expand=True)[0], format='%Y-%m-%d')

#%%
review_clean1.head()

#%%
review_users = review_clean1['user_id'].tolist()
review_users1 = list(set(review_users))

#%%
print(review_users)

#%%
# save as json
with open("./data/review_users.json", 'w') as file:
    file.writelines(json.dumps(review_users1)+'\n')

#%%
# save as csv
review_clean1.to_csv("./data/review_tor_restaurant.csv", index=False)
