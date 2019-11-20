# Function of Files in Repo



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
