from textblob import TextBlob
import sys
import tweepy
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import nltk
import re
import string

#nltk.downloader.download('vader_lexicon')

# some more specific packages needed
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from langdetect import detect
from nltk.stem import SnowballStemmer
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from sklearn.feature_extraction.text import CountVectorizer


# we create a few lists that will contains the tweets relevant to a pos, neg or neu descriptor
pos_list = []
neg_list = []
neu_list = []

# now we also have three counters to keep track of the number of positive, negative or neutral tweets
pos_count = 0
neg_count = 0
neu_count = 0

# we also have a polarity sore that can go from -1 to 1 and 1 indicating very positive and -1 very negative
total_polarity = 0


example_tweet = "this drug is the worst thing ever!!! @biden"

analysis = TextBlob(example_tweet)
#use the sentiment analyzer to get the polarity scores, dictionary stores it all
score = SentimentIntensityAnalyzer().polarity_scores(example_tweet)

# update the total polarity score by accessing the individual polarity of that single tweet
total_polarity += analysis.sentiment.polarity

# if the negative score is greater than positive score it is a negative tweet
if score['neg'] > score['pos']:
    neg_count+=1
    neg_list.append(example_tweet)

# otherwise positive could be greater than the negative
elif scor['pos']>score['neg']:
    pos_count+=1
    pos_list.append(example_tweet)

# here we must be a neutral tweet
else:
    neu_count+=1
    neu_list.append(example_tweet)


print("this is the count for each three counts: ",neg_count,pos_count,neu_count)
