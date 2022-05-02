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
import os

#nltk.downloader.download('vader_lexicon')

# some more specific packages needed
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from langdetect import detect
from nltk.stem import SnowballStemmer
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from sklearn.feature_extraction.text import CountVectorizer


# Here is the fetching of the raw data
#file_path="/gpfs/data/biol1555/projects2022/team06/6_project/data/celexa.txt"
#processed_data = open(file_path,'r')#,encoding="utf-8")



def get_data_filepaths(drug):
    file = drug+".txt"
    return os.path.join('/gpfs/data/biol1555/projects2022/team06/6_project/data/', file)

def get_raw_tweets(filepath):
    raw_tweets = []
    datafile = open(filepath, 'r')
    for line in datafile.readlines():
        raw_tweet = line.split('|')[1]
        if raw_tweet == "raw_tweet":
            continue
        raw_tweets.append(raw_tweet)
    return raw_tweets

def sentiment_analysis(documents):
    tweets = [line.decode('utf-8').strip() for line in documents]

    # now we also have three counters to keep track of the number of positive, negative or neutral tweets
    pos_count = 0
    neg_count = 0
    neu_count = 0

    # we also have a polarity sore that can go from -1 to 1 and 1 indicating very positive and -1 very negative
    total_polarity = 0

    for tweet in tweets:
        analysis = TextBlob(tweet)

        #use the sentiment analyzer to get the polarity scores, dictionary stores it all
        score = SentimentIntensityAnalyzer().polarity_scores(tweet)
    
        # update the total polarity score by accessing the individual polarity of that single tweet
        total_polarity += analysis.sentiment.polarity

        # if the negative score is greater than positive score it is a negative tweet
        if score['neg'] > score['pos']:
            neg_count+=1

        # otherwise positive could be greater than the negative
        elif score['pos']>score['neg']:
            pos_count+=1

        # here we must be a neutral tweet
        else:
            neu_count+=1


def main():
    drug_list = ["zoloft", "cymbalta", "celexa", "viibryd", "pristiq"]
    for drug in drug_list:

        filepath = get_data_filepaths(drug)
        raw_tweets = get_raw_tweets(filepath)
        sentiment_analysis(raw_tweets)

    #print(f'{drug} sentiment results: {sentiments}')
    print('all done!')

if __name__ == "__main__":
    main()
#print("this is the count for each three counts: ",neg_count,pos_count,neu_count)
