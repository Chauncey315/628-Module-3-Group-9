import os
import numpy as np 
import pandas as pd 
import json

# set running directory
# os.chdir()

# load users with reviews
u_review = pd.read_csv("./data/data_asianrestaurant/review/review_tor_restaurant.csv")
u_review_dic = {}
review_user = u_review.user_id.tolist()
review_business = u_review.business_id.tolist()
for i in range(len(review_user)):
    if review_user[i] in u_review_dic.keys():
        u_review_dic[review_user[i]].append(review_business[i])
    else:
        u_review_dic[review_user[i]] = []
        u_review_dic[review_user[i]].append(review_business[i])

# delete same values in list
for key in u_review_dic.keys():
    if len(u_review_dic[key]) > 1:
        u_review_dic[key] = list(set(u_review_dic[key]))

# for key in u_review_dic.keys():
#     if len(u_review_dic[key]) > 1:
#         print(key)

# load users with tips
u_tips = pd.read_csv("./data/data_asianrestaurant/tips/tips_tor_restaurant.csv")

# merge same users to different tips
u_tips_dic = {}
tips_user = u_tips.user_id.tolist()
tips_business = u_tips.business_id.tolist()
for i in range(len(tips_user)):
    if tips_user[i] in u_tips_dic.keys():
        u_tips_dic[tips_user[i]].append(tips_business[i])
    else:
        u_tips_dic[tips_user[i]] = []
        u_tips_dic[tips_user[i]].append(tips_business[i])

# delete same values in list
for key in u_tips_dic.keys():
    if len(u_tips_dic[key]) > 1:
        u_tips_dic[key] = list(set(u_tips_dic[key]))

# for key in u_tips_dic.keys():
#     if len(u_tips_dic[key]) > 1:
#         print(key)

# merge two dicts
u2b_dic = {}
u2b_dic = u_tips_dic.copy()
u2b_dic.update(u_review_dic)

for key in u2b_dic.keys():
    if key in u_tips_dic.keys():
        u2b_dic[key] = list(set(u2b_dic[key] + u_tips_dic[key]))            

# for key in u2b_dic.keys():
#     if len(u2b_dic[key]) > 1:
#         print(key)

# dict saved to json
with open("./data/network/u2b.json", 'w') as file:
    file.writelines(json.dumps(u2b_dic)+'\n')

# i = 0
# for key in u_review_dic.keys():
#     if key in u_tips_dic.keys():
#         i += 1
# print(i)
