import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re
#words cloud
import wordcloud
from wordcloud import WordCloud, STOPWORDS 
import nltk
from nltk.corpus import stopwords
from PIL import Image
import urllib
import requests


review = pd.read_csv("review_tor_restaurant.csv") 
sns.countplot('stars', data = review, palette=sns.cubehelix_palette(8))
plt.title('Star Distribution of User Ratings')

#Explore the relationships between open/close status and star ratings
business['is_open'].value_counts()
business_open = business.loc[business['is_open']==1]
mean(business_open['stars'])
business_close = business.loc[business['is_open']==0]
mean(business_close['stars'])
#Plot the figure
sns.countplot('stars', data = business, hue='is_open', palette=sns.cubehelix_palette(8))
plt.legend()
plt.xlabel('Number of Stars')
plt.ylabel('Number of Restaurants')
plt.title('Distribution of Stars: Opened Versus Closed Restaurants')
#plot the stars on different five categories
sns.countplot('stars', data = business, hue='new_category', palette=sns.cubehelix_palette(8))
plt.legend()
plt.xlabel('Number of Stars')
plt.ylabel('Number of Restaurants')
#Top 50 Restaurants
top_business = business[['name', 'review_count', 'city', 'stars']].sort_values(ascending=False, by="review_count")[0:50]
top_business = pd.DataFrame(data=top_business)
#top_business.head()
top_business=top_business.set_index('name')
#top_business.head()
top_business[0:25].sort_values(ascending=False, by="review_count")\
.plot(kind='barh', stacked=False, figsize=[10,10], colormap='Paired')
top_business = business[['name', 'review_count', 'city', 'stars']].sort_values(ascending=False, by="review_count")[0:100]
top_business = pd.DataFrame(data=top_business)
sns.countplot('stars', hue='city',data = top_business,palette=sns.cubehelix_palette(8))
plt.legend()
business_chinese = business.loc[business['new_category'] == 'Chinese']
business_korean = business.loc[business['new_category'] == 'Korean']
business_japan = business.loc[business['new_category'] == 'Japanese']
business_Vietnamese = business.loc[business['new_category'] == 'Vietnamese']
business_Thai = business.loc[business['new_category'] == 'Thai']
# Chinese word cloud
lst_id = business_chinese['business_id']
review_text_chn = ''
for val in lst_id:
    temp = review.loc[review['business_id'] == val]
    temp_text = temp['text']
    for item in temp_text:
        review_text_chn += item


mask = np.array(Image.open(requests.get('http://www.clker.com/cliparts/O/i/x/Y/q/P/yellow-house-hi.png', stream=True).raw))
review_text = clean(review_text_chn)
words = 1
words_tokens = nltk.word_tokenize(review_text)
stop_words=set(stopwords.words('english'))
filtered_sentence = [w for w in words_tokens if not w in stop_words] 
comments = ' '.join([str(elem) for elem in filtered_sentence])
wordcloud = WordCloud(width = 800, height = 800, 
background_color ='white', 
stopwords = ['came','much','make','really','get','got','one','like','also','restaurant','like','ordered','bit',
                                    'place','table','dishes','order','good','however','lot','though','still','thing','think',
                                    'although','well','even','Chinese','food','since','way'], mask=mask, colormap='Reds',
                        min_font_size = 10).generate(comments) 
          
        # plot the WordCloud image                        
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(wordcloud) 
plt.axis("off") 
plt.tight_layout(pad = 0) 
plt.show() 

#Korean word cloud
lst_id = business_korean['business_id']
mask = np.array(Image.open(requests.get('http://www.clker.com/cliparts/O/i/x/Y/q/P/yellow-house-hi.png', stream=True).raw))
review_text_kor = ''
for val in lst_id:
    temp = review.loc[review['business_id'] == val]
    temp_text = temp['text']
    for item in temp_text:
        review_text_kor += item
review_text = clean(review_text_kor)
words = 1
words_tokens = nltk.word_tokenize(review_text)
stop_words=set(stopwords.words('english'))
filtered_sentence = [w for w in words_tokens if not w in stop_words] 
comments = ' '.join([str(elem) for elem in filtered_sentence])
wordcloud = WordCloud(width = 800, height = 800, 
                background_color ='white', 
                stopwords = ['came','much','make','really','get','got','one','like','also','restaurant','like','ordered','bit',
                            'place','table','dishes','order','good','however','lot','though','still','thing','think',
                            'although','well','food','way','actually','since','could','tried','maybe','korean'], colormap='BuPu',mask=mask,
                min_font_size = 10).generate(comments) 
  
# plot the WordCloud image                        
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(wordcloud) 
plt.axis("off") 
plt.tight_layout(pad = 0) 
plt.show() 

#Japanese word cloud
mask = np.array(Image.open(requests.get('http://www.clker.com/cliparts/O/i/x/Y/q/P/yellow-house-hi.png', stream=True).raw))
lst_id = business_japan['business_id']
review_text_jap = ''
for val in lst_id:
    temp = review.loc[review['business_id'] == val]
    temp_text = temp['text']
    for item in temp_text:
        review_text_jap += item
review_text = clean(review_text_jap)
words = 1
words_tokens = nltk.word_tokenize(review_text)
stop_words=set(stopwords.words('english'))
filtered_sentence = [w for w in words_tokens if not w in stop_words] 
comments = ' '.join([str(elem) for elem in filtered_sentence])
wordcloud = WordCloud(width = 800, height = 800, 
                background_color ='white', 
                stopwords = ['came','much','make','really','get','got','one','like','also','restaurant','like','ordered','bit',
                            'place','table','dishes','order','good','however','lot','though','still','thing','think',
                            'although','well','even','way','actually','since','could','tried','maybe','eat','dish'], mask=mask,colormap='PuRd',
                min_font_size = 10).generate(comments) 
  
# plot the WordCloud image                        
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(wordcloud) 
plt.axis("off") 
plt.tight_layout(pad = 0) 
plt.show() 

#Vietnamnese 
lst_id = business_Vietnamese['business_id']
mask = np.array(Image.open(requests.get('http://www.clker.com/cliparts/O/i/x/Y/q/P/yellow-house-hi.png', stream=True).raw))
review_text_viet = ''
for val in lst_id:
    temp = review.loc[review['business_id'] == val]
    temp_text = temp['text']
    for item in temp_text:
        review_text_viet += item
review_text = clean(review_text_viet)
words = 1
words_tokens = nltk.word_tokenize(review_text)
stop_words=set(stopwords.words('english'))
filtered_sentence = [w for w in words_tokens if not w in stop_words] 
comments = ' '.join([str(elem) for elem in filtered_sentence])
wordcloud = WordCloud(width = 800, height = 800, 
                background_color ='white', 
                stopwords = ['came','much','make','really','get','got','one','like','also','restaurant','like','ordered','bit',
                            'place','table','dishes','order','good','however','lot','though','still','thing','think',
                            'although','well','even','way','actually','since','could','tried','maybe','usually','made','eat',
                            'dish','alway','feel','give','vietnamese','food','menu','would','dont'], mask=mask, colormap='BuPu',
                min_font_size = 10).generate(comments) 
  
# plot the WordCloud image                        
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(wordcloud) 
plt.axis("off") 
plt.tight_layout(pad = 0) 
plt.show() 

#Thai
lst_id = business_Thai['business_id']
mask = np.array(Image.open(requests.get('http://www.clker.com/cliparts/O/i/x/Y/q/P/yellow-house-hi.png', stream=True).raw))
review_text_thai = ''
for val in lst_id:
    temp = review.loc[review['business_id'] == val]
    temp_text = temp['text']
    for item in temp_text:
        review_text_thai += item
review_text = clean(review_text_thai)
words = 1
words_tokens = nltk.word_tokenize(review_text)
stop_words=set(stopwords.words('english'))
filtered_sentence = [w for w in words_tokens if not w in stop_words] 
comments = ' '.join([str(elem) for elem in filtered_sentence])
wordcloud = WordCloud(width = 800, height = 800, 
                background_color ='white', 
                stopwords = ['came','much','make','really','get','got','one','like','also','restaurant','like','ordered','bit',
                            'place','table','dishes','order','good','however','lot','though','still','thing','think',
                            'although','well','even','food','people','dish','take','thought','menu','eat','would',
                            'thats','since','always','dont','could','go','way'],mask=mask, colormap='PuBu', 
                min_font_size = 10).generate(comments) 
# plot the WordCloud image                        
#plt.figure(figsize = (8, 8), facecolor = None) 
#plt.imshow(wordcloud) 
#plt.axis("off") 
#plt.tight_layout(pad = 0) 
#plt.show() 

#Some supplementary functions

#Tokenize 2-gram, it will generate a dictionary where the keys are 
#two words, and the third one is the word usually follows after the two words.
def two_gram(text):
    ngrams = {}
    words = 2
    words_tokens = nltk.word_tokenize(text)
    for i in range(len(words_tokens)-words):
        seq = ' '.join(words_tokens[i:i+words])
        #print(seq)
        if  seq not in ngrams.keys():
            ngrams[seq] = []
        ngrams[seq].append(words_tokens[i+words])
    return ngrams

#all the letters will be in lower case, and we move all the characters except letters and .
def clean(text):
    text = text.lower()
    text = re.sub(r'[^A-Za-z. ]', '', text)
    return text

def user_comment_count(review):
    view = []
    #dict = {}
    val =[]
    for user in review['user_id']:
        if user not in view:
            view.append(user)
            #dict[user] = sum(review['user_id'] == user)
            val.append(sum(review['user_id'] == user))
    return val




