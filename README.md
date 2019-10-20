# Yelp Dataset

## Introduction
Because the dataset is of size about 7GB, we will use [Google colab](https://colab.research.google.com/notebooks/welcome.ipynb) to load and analyze the dataset. To save the time of uploading dataset onto Goolge colab evrytime we start a new remote host, we upload the `csv` version of dataset onto Google Drive, and mount Google Drive to the remote host. 

One can get the dataset via the this [link](https://drive.google.com/drive/folders/11vqfdfv8skQDKFc8RmT4S1HjFsQw1V7I?usp=sharing). 

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

2. model selection
    (a)LDA
    *(b)Xgboost
    *(c)LSTM

3. visualize
    (a)wordcloud
















Reference

1. [Latent Dirichlet Allocation](https://github.com/kapadias/mediumposts.git)
2. 
