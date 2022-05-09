from textblob import TextBlob
import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import re
import string
import pandas as pd
import os
import seaborn as sns

def sentiment_analysis(df):
    analyzer = SentimentIntensityAnalyzer()
    df = df.reset_index()
    pos_count = 0
    neg_count = 0
    neu_count = 0

    for index in df.index:

        tweet = df.loc[index, 'raw_tweet']
        analysis = TextBlob(tweet)

        # use the sentiment analyzer to get the polarity scores, dictionary stores it all
        score = analyzer.polarity_scores(tweet)

        # if the negative score is greater than positive score it is a negative tweet
        if score['neg'] > score['pos']:
            neg_count+=1
            # neg_count.append(1)/

        # otherwise positive could be greater than the negative
        elif score['pos']>score['neg']:
            pos_count+=1

        # here we must be a neutral tweet
        else:
            neu_count+=1
        
    return pos_count, neg_count, neu_count

def main():

    output = open("nltk_analysis_output.txt", "w")
    drug_list = ["zoloft", "cymbalta", "celexa", "viibryd", "pristiq"]
    for drug in drug_list:

        filepath = "~/Desktop/" + drug + ".txt"
        my_data = pd.read_csv(filepath, sep="|")

        pos, neg, neu = sentiment_analysis(my_data)
        data = [pos, neg, neu]
     
        data = pd.DataFrame(data)
      
        data.columns = ["val"]
        # plot_counts(data, drug)
    
        pos, neg, neu = sentiment_analysis(my_data)
        data = [pos, neg, neu]
    
        # write data onto output file
        output.write(drug + "|" + str(data[0]) + "|" + str(data[1]) + "|" + str(data[2]) + "\n")

    output.close()

if __name__ == "__main__":
    main()
