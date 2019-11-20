#%%
import numpy as np 
import pandas as pd 
import json 

#%%
users = pd.read_csv('../data/user_tor_restaurant/user_tor_restaurant.csv')
with open("../new_data/review/review_users.json", 'r') as f1:
    review_users = json.load(fp=f1)
with open("../new_data/tips/tips_users.json", 'r') as f2:
    tips_users = json.load(fp=f2)  

#%%
raw_users_list = review_users + tips_users
users_list = list(set(raw_users_list))
# print(len(review_users))
# print(len(tips_users))
# print(len(users_list))

#%%
with open("../new_data/user/users_list.json", 'w') as file:
    file.writelines(json.dumps(users_list)+'\n')

#%%
users = users[users.user_id.isin(users_list)]

#%%
users.to_csv("../new_data/user/user_tor_asianrestaurant.csv", index=False)

#%%
users_tor = users
users_elite = users_tor.dropna(subset=['elite'])
elite_dic = users_elite.set_index('user_id').to_dict('dict')['elite']
for key in elite_dic:
        elite_dic[key] = list(str(elite_dic[key]).split(','))
        elite_dic[key] = list(map(int, elite_dic[key]))
# print(elite_dic)

#%%
with open("../new_data/user/elite_dic.json", 'w') as file:
    file.writelines(json.dumps(elite_dic)+'\n')

#%%
users_tor.drop(labels=['elite'], axis=1, inplace=True)

#%%
users_tor.to_csv("../new_data/user/user_tor_restaurant_noelite.csv", index=False)

#%%
