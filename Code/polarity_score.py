#Polarity Score Code
import pandas as pd
import requests, re
import pandas as pd
import seaborn as sns
import nltk
import string, itertools
import matplotlib.pyplot as plt
from nltk.text import Text
from nltk.tokenize import word_tokenize, sent_tokenize, regexp_tokenize
from nltk.corpus import stopwords
from sklearn.model_selection import train_test_split
review = pd.read_csv("review_tor_restaurant.csv") 
business = pd.read_csv("asian_restaurant.csv")

#supplemantary functions
def clean_text(text):
    text = re.sub(r'[^A-Za-z ]', '', text)
    text = text.lower()
    return(text)
#This will extract the all the reviews of one specific categor restaurants
def find_category(category):
    df = data[['clean_review','labels']][data.new_category==category]
    df.reset_index(drop=True, inplace =True)
    df.rename(columns={'clean_review':'review'}, inplace=True)
    return df
def split_data(data, test_size):
    train, test = train_test_split(data[['review','labels']],test_size=test_size)
    return train
def filter_words(review):
    lemmatizer = WordNetLemmatizer() 
    stop_list = ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', "you're", "you've", "you'll", 
 "you'd", 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', "she's", 'her', 'hers', 
 'herself', 'it', "it's", 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 
 'whom', 'this', 'that', "that'll", 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 
 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 
 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 
 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 
 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 
 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 
 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don', "don't", 'should', "should've", 'now', 'd', 'll', 
 'm', 'o', 're', 've', 'y', 'ain', 'aren', "aren't", 'couldn', "couldn't", 'didn', "didn't", 'doesn', "doesn't", 
 'hadn', "hadn't", 'hasn', "hasn't", 'haven', "haven't", 'isn', "isn't", 'ma', 'mightn', "mightn't", 'mustn', 
 "mustn't", 'needn', "needn't", 'shan', "shan't", 'shouldn', 
 "shouldn't", 'wasn', "wasn't", 'weren', "weren't", 'won', "won't", 'wouldn', "wouldn't"]
    my_list = ['try','would','definitely','toronto','highly','made','time','around','also','everything','come'
           ,'comes','really','restaurant','restaurants','im','ive','must','recommend','next','one','always','japanese'
              ,'korean','chinese','vietnamnese','thai','wasnt','person','came','dont','nothing','however','much','end','bit'
              ,'especially','also','always','definitely','highly','around','got','cant','purple','go','get','brought',
              'could','lot','didnt','ordered','used','many']
    #words = [word for word in review.split() if word not in stop_list]
    words = []
    for word in review.split():
        if word not in stop_list+my_list:
            word = lemmatizer.lemmatize(word)
            words.append(word)
    words = ' '.join(words)
    return words

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.svm import LinearSVC

def polarity_score(category):
    reviews_k = find_category(category)
    train, test = train_test_split(reviews_k[['review','labels']],test_size=0.7)
    train.review = train.review.apply(filter_words)
    x_train,y_train=list(train['review']),list(train['labels'])
    x_test,y_test=list(test['review']),list(test['labels'])  
    vectorizer = CountVectorizer()
    feature_train_counts=vectorizer.fit_transform(x_train)
    svm = LinearSVC()
    svm.fit(feature_train_counts, y_train)
    coeff = svm.coef_[0]
    words_score = pd.DataFrame({'score': coeff, 'word': vectorizer.get_feature_names()})
    words_score.set_index('word', inplace=True)
    polarity_score = words_score
    reviews_k = pd.DataFrame(feature_train_counts.toarray(), columns=vectorizer.get_feature_names())
    reviews_k['labels'] = y_train
    frequency = reviews_k[reviews_k['labels'] =='positive'].sum()[:-1]
    polarity_score['frequency'] = frequency
    polarity_score['polarity'] = polarity_score.score * polarity_score.frequency / reviews_k.shape[0]
    pos_mylist = polarity_score.loc[['amazing','love','best','awesome','excellent','good','great',
                                                    'favorite','favourite','loved','perfect','gem','perfectly','wonderful',
                                                    'happy','enjoyed','nice','well','super','like','better','decent','fine',
                                                    'pretty','enough','excited','impressed','ready','fantastic','glad','right',
                                                    'fabulous','every','sure','place','surprised','quite']]
    neg_mylist = polarity_score.loc[['bad','disappointed','unfortunately','disappointing','horrible',
                                                     'lacking','terrible','sorry', 'disappoint','although']]

    polarity_score.drop(pos_mylist.index, axis=0, inplace=True)
    polarity_score.drop(neg_mylist.index, axis=0, inplace=True)
    return(polarity_score)

def plot_top_words(top_words, category):
    plt.figure(figsize=(11,6))
    colors = ['grey' if c < 0 else 'pink' for c in top_words.values]
    sns.barplot(y=top_words.index, x=top_words.values, palette=colors)
    plt.xlabel('Polarity Score', labelpad=10, fontsize=14)
    plt.ylabel('Words', fontsize=14)
    plt.title('Positive and Negative Words in %s Restaurants ' % category, fontsize=15)
    plt.tick_params(labelsize=14)
    plt.xticks(rotation=15)
    
    data = pd.merge(business, review, on = 'business_id')
    data.rename(columns={'stars_x':'avg_star','stars_y':'review_star'}, inplace=True)
    data['words_count'] = data.text.str.replace('\n',''). \
                                              str.replace('[!"#$%&\()*+,-./:;<=>?@[\\]^_`{|}~]','').map(lambda x: len(x.split()))
    data['labels'] = ''
    data.loc[data.review_star >=4, 'labels'] = 'positive'
    data.loc[data.review_star <4, 'labels'] = 'negative'
    data['clean_review'] = [clean_text(review) for review in data.text]

# Example: Thai
polarity_score_k = polarity_score('Thai')
polarity_score_k[polarity_score_k.polarity>0].sort_values('polarity', ascending=False)[:10]
polarity_score_k[polarity_score_k.polarity<0].sort_values('polarity', ascending=True)[:10]

positive_words = ['delicious','friendly','curry','fresh','salad','khao']
negative_words = ['food','pad','portions','soup','small','service','atmosphere']
top_words = polarity_score_k.loc[positive_words+negative_words,'polarity']


    