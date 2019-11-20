#%%
import numpy as np 
import pandas as pd 

#%%
# read user data
users = pd.read_csv("./data/user.csv", low_memory=False)

#%%
# read user related data 'reviews' and 'tips'
import json
with open("./data/review_users.json", 'r') as f1:
    review_users = json.load(fp=f1)
with open("./data/tips_users.json", 'r') as f2:
    tips_users = json.load(fp=f2)  

#%%
# all related users list
raw_users_list = review_users + tips_users
users_list = list(set(raw_users_list))
print(len(review_users))
print(len(tips_users))
print(len(users_list))

#%%
# save as json
with open("./data/users_list.json", 'w') as file:
    file.writelines(json.dumps(users_list)+'\n')

#%%
users.head()

#%%
with open("./data/users_list.json", 'r') as f3:
    users_list = json.load(fp=f3)

#%%
# process the user dataset
users = users[users.user_id.isin(users_list)]
users = users.dropna(axis=1, how='all')
#%%
users.head()

#%%
# process the column 'since_time' and 'since_year'
users['since_time'] = users.yelping_since.str.split(' ', expand=True)[1]
users['since_year'] = pd.to_datetime(users.yelping_since.str.split(' ', expand=True)[0], format='%Y-%m-%d')
users.drop(labels=['yelping_since'], axis=1, inplace=True)

#%%
year = users['since_year']
users.drop(labels=['since_year'], axis=1, inplace=True)
users.insert(3, 'since_year', year)
time = users['since_time']
users.drop(labels=['since_time'], axis=1, inplace=True)
users.insert(4, 'since_time', time)

#%%
users.head()

#%%
# save as csv
users.to_csv("./data/user_tor_restaurant.csv", index=False)

#%%
# save as csv
users_tor = pd.read_csv("./data/user_tor_restaurant.csv")

#%%
users_tor.head()

#%%
# process the column 'elite'
users_elite = users_tor.dropna(subset=['elite'])

#%%
users_elite.head()

#%%
# build elite data
elite_dic = users_elite.set_index('user_id').to_dict('dict')['elite']
for key in elite_dic:
        elite_dic[key] = list(str(elite_dic[key]).split(','))
        elite_dic[key] = list(map(int, elite_dic[key]))
print(elite_dic)

#%%
# save as json
import json
with open("./data/elite_dic.json", 'w') as file:
    file.writelines(json.dumps(elite_dic)+'\n')

#%%
users_tor.head()

#%%
# drop na
users_tor.drop(labels=['elite'], axis=1, inplace=True)

#%%
users_tor.head()

#%%
# save as csv
users_tor.to_csv("./data/user_tor_restaurant.csv", index=False)
