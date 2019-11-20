import pandas as pd
review = pd.read_csv("review_tor_restaurant.csv") 
business = pd.read_csv("asian_restaurant.csv") 
attr = pd.read_csv("attribute_business.csv")
review['labels'] = ''
review.loc[review.stars >=4, 'labels'] = 'pos'
review.loc[review.stars <=3, 'labels'] = 'neg'

from nltk.tokenize import word_tokenize
from nltk import pos_tag
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from sklearn.preprocessing import LabelEncoder
from collections import defaultdict
from nltk.corpus import wordnet as wn
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import model_selection, naive_bayes, svm
from sklearn.metrics import accuracy_score

import re
import string
import nltk
from nltk import pos_tag
from nltk.corpus import stopwords
from nltk.tokenize import WhitespaceTokenizer
from nltk.stem import WordNetLemmatizer

def clean_text(text):
    lemmatizer = WordNetLemmatizer() 
    text = text.lower()
    text = lemmatizer.lemmatize(text)
    text = re.sub(r'[^A-Za-z ]', '', text)
    text = [word.strip(string.punctuation) for word in text.split(" ")]
    stop = stopwords.words('english')
    text = [x for x in text if x not in stop]
    text = [t for t in text if len(t) > 0]
    text = [lemmatizer.lemmatize(word) for word in text]
    text = " ".join(text)
    text = nltk.word_tokenize(text)
    return(text)

review['review_clean'] = review.text.apply(clean_text)
import numpy as np
Train_X, Test_X, Train_Y, Test_Y = model_selection.train_test_split(review["review_clean"],review['labels'],test_size=0.3)
Tfidf_vect = TfidfVectorizer(max_features=5000)
Tfidf_vect.fit(review["review_clean"].apply(lambda x: np.str_(x)))
Train_X_Tfidf = Tfidf_vect.transform(Train_X.apply(lambda x: np.str_(x)))
Test_X_Tfidf = Tfidf_vect.transform(Test_X.apply(lambda x: np.str_(x)))

# fit the training dataset on the NB classifier
Naive = naive_bayes.MultinomialNB()
Naive.fit(Train_X_Tfidf,Train_Y)
# predict the labels on validation dataset
predictions_NB = Naive.predict(Test_X_Tfidf)
# Use accuracy_score function to get the accuracy
print("Naive Bayes Accuracy Score -> ",accuracy_score(predictions_NB, Test_Y)*100)

from sklearn.metrics import f1_score
f1_score(predictions_NB, Test_Y, average=None)