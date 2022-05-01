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
import pandas as pd

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

# Here is the fetching of the raw data
file_path="/gpfs/data/biol1555/projects2022/team06/6_project/data/celexa.txt"
processed_data = open(file_path,'r')#,encoding="utf-8")

tweets = [line.decode('utf-8').strip() for line in processed_data.readlines()]

for tweet in tweets:
    
    analysis = TextBlob(tweet)

    #use the sentiment analyzer to get the polarity scores, dictionary stores it all
    score = SentimentIntensityAnalyzer().polarity_scores(tweet)
    
    # update the total polarity score by accessing the individual polarity of that single tweet
    total_polarity += analysis.sentiment.polarity

    # if the negative score is greater than positive score it is a negative tweet
    if score['neg'] > score['pos']:
        neg_count+=1
        neg_list.append(tweet)

    # otherwise positive could be greater than the negative
    elif score['pos']>score['neg']:
        pos_count+=1
        pos_list.append(tweet)

    # here we must be a neutral tweet
    else:
        neu_count+=1
        neu_list.append(tweet)

print("this is the count for each three counts: ",neg_count,pos_count,neu_count)
