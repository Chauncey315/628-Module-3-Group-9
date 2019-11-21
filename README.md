## Shiny App

This is a the [address](https://yezoli.shinyapps.io/Yelp-Business-Analysis/) of our shiny app



## Dataset

The following list shows the original or cleaned datasets we used in this analysis. some small files have been uploaded to this repository, while some large files are not. 

|              Dataset              |                           Comment                            |
| :-------------------------------: | :----------------------------------------------------------: |
|       `tor_restaurant.csv`        |              restaurant in Toronto distriction               |
|       `restaurant_dic.json`       |     dictionary of restaurant name mapping to categories      |
|      `review_tor_restaurant`      |               review on restaurant in Toronto                |
|        `review_users.json`        |         users who reviewed on restaurant in Toronto          |
|     `tips_tor_restaurant.csv`     |              tips data of restaurant in Toronto              |
|         `tips_users.json`         |         users who gave tips on restaurant in Toronto         |
|     `user_tor_restaurant.csv`     | data of users who reviewed and gave tips on restaurant in Toronto |
| `user_tor_restaurant_noelite.csv` |          user_to_restaurant without column 'elite'           |
|         `elite_dic.json`          | users who reviewed and gave tips on restaurant in Toronto mapping to elite year |
|         `users_list.json`         | users who reviewed and gave tips on restaurant in Toronto(No Duplicates) |



## Function of Files in Repository

#### Misc

contains miscellaneous archived *deserted* files, like, 

* `codeArchive.R` contains deserted codes
* `Code.ipynb` tries to load data onto google drive and 

####  Code

contains the codes to clean, analyze the dataset

* `100user_analysis.ipynb` finds out top 100 most influential users
* `628_EDA_code.py` performs exploratory analysis on the dataset
* `polarity_score` calculates restaurants' popularity score
* `prediction.py` develops a model to predict user's star for restaurants based on the review
* `final_report_yelp.ipynb` is the final interactive report of the project
* `clean_data` contains codes to clean the dataset
* `network` contains the codes of social network analysis

#### image

Contains images used in report, slides and jupyter notebook

#### Shiny

Contains the whole shiny project

* `analysis`

  Contains html of 5 cusines' analysis

* `app.R`

  Define shiny's UI and Server behavior

* `global.R` 

  Define datasets, variables and functions that `app.R` needs. 

* `data`

  contains csvs that `global.R` needs and original `docx` version of cuisine analysis

* `pic` 

  Contains images for button

* `www`

  Contains `css` files and various images. 

#### Summary 

The final summary of our project. 

#### Slide

The final slide of our project. 







## Step
### Clean Data
1. clean business dataset
2. select category 'restaurant' -> ['Toronto', 'Mississauga', 'Markham', 'North York', 'Scarborough', 'Richmond Hill', 'Vaughan']
3. clean other dataset under the condition

### Data analysis
#### business
1. distribution of the stars
2. restaurant category
3. relation 'star' with food category
4. visulize in map under country and city

#### check-in
1. time and times

#### users and reviews
1. top numbers of users
2. times of reviews

### NLP
#### pre-processing
1. get_data
2. token
3. lemma/stem/pos tag
4. stopwords
5. wordlist/dictionary

#### sentiment analysis
1. feature engineering 
    (a) bi-gram + TF-IDF
    (b) W2V
        (1) t-sne

3. visualize
    (a)wordcloud

### Business suggestion

**Goal**: Give advice to business owners who want to open a new restaurant in a particular city (analyze Great Toronto Area as example)

**Subject**: focus on `restaurant` 

**Shiny App**

* Analyze Great Toronto Area & visualize, interpret the result

**Perspectives**

* Location: plot restaurant on map, clustering to find business hub
* Food Type: extract information from the `category` column in `business.csv`
* Peak hour detection: use `data` column in `tip.csv` to find peak hour of a given restaurant or a given city.
* Waiter Improvement: analysis `text` column in `tip.csv` to find improvement advice to waiters
* Customer returning rate and feature of those customer
* Advertisement Advise
  * Goal: Use minimum amount of advertisement to get maximum effect in a given city
  * Preprocess:
    * assign each user a `city` label, which is the city where user has dined most times
    * Use `friend` column in `user.csv` to construct a network(graph)
  * Selection Algorithm: 
    * Find [central point](https://programminghistorian.org/en/lessons/exploring-and-analyzing-network-data-with-python#basics-of-networkx-creating-the-graph) of the network, regard them as advertisement recipients
    * [Clustering graph](https://www.csc2.ncsu.edu/faculty/nfsamato/practical-graph-mining-with-R/slides/pdf/Graph_Cluster_Analysis.pdf), sample important points from each cluster
    * Construct matrix of users, calculate `Graph Clustering Rate` `Transtivity` 







## Contributor

|     Name     |       Email       |
| :----------: | :---------------: |
| Chushi, Shi  |  cshi46@wisc.edu  |
| Fangfei, Lin |  Flin29@wisc.edu  |
|   Lu, Chen   | lchen487@wisc.edu |
|  Yezhou, Li  |  yli967@wisc.edu  |
