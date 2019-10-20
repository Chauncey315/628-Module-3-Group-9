****

## 10.20 Meeting

**Goal**: Give advice to business owners who want to open a new restaurant in a particular city (analyze Great Toronto Area as example)

**Subject**: focus on `restaurant` 

**Shiny App**

* Analyze Great Toronto Area & visualize, interpret the result
* Provide function to analyze any given city & visualize the result

**Perspectives**

* Location: plot restaurant on map, clustering to find business hub
* Food Type: extract information from the `category` column in `business.csv`
* Peak hour detection: use `data` column in `tip.csv` to find peak hour of a given restaurant or a given city.
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