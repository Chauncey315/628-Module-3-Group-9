#%%
import os
import json
import numpy as np 
import pandas as pd 

#%%
# set running directory
# os.chdir()

#%%
# read u2u.json
with open("./data/network/u2u_pagerank.json", 'r') as f:
    u2u_pr = json.load(fp=f)

df_u2u_pr = pd.DataFrame((u2u_pr.items()))
df_u2u_pr.columns = ['user_id', 'score']
df_u2u_pr.head()

#%%
df_u2u_pr = df_u2u_pr.sort_values('score', ascending=False)
df_u2u_pr.reset_index(inplace=True)
df_u2u_pr.head()

#%%
df_u2u_pr.drop('index', axis=1, inplace=True)
df_u2u_pr.drop(index=[0], inplace=True)
df_u2u_pr.reset_index(drop=False, inplace=True)
df_u2u_pr.head(100)

#%%
df_top100 = df_u2u_pr.loc[[x for x in range(100)],]
df_top100.head()

#%%
top100user_dic = df_top100.set_index('user_id').to_dict('dict')['score']

#%%
with open("./data/network/top100user_dic.json", 'w') as file:
    file.writelines(json.dumps(top100user_dic)+'\n')

#%%
