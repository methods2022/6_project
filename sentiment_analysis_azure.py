import pandas as pd
import sys
import os
from azure.core.credentials import AzureKeyCredential
from azure.ai.textanalytics import TextAnalyticsClient

_DRUGS_DIR = 'data/'
_ENDPOINT = ''
_KEY = ''
_BATCH_SIZE = 10

def get_drug_csv_filepaths(drug):
    file = drug+".csv"
    return os.path.join(_DRUGS_DIR, file)

def get_raw_tweets(filepath):
    df = pd.read_csv(filepath)
    return df['raw_tweet'].to_list()

def get_processed_tweets(filepath):
    df = pd.read_csv(filepath)
    return df['processed_tweet'].to_list()


def sentiment_analysis(client, documents):
    size = len(documents)
    sentiments = {}
    for index in range(0, size, _BATCH_SIZE):
        response = client.analyze_sentiment(documents=documents[index:index+_BATCH_SIZE])
        for doc in response:
            if doc.sentiment not in sentiments:
                sentiments[doc.sentiment] = 0
            sentiments[doc.sentiment] += 1
    return sentiments

def main(args):
    if len(args) != 2:
        print("Run script as: sentiment_analysis_azure.py <drug_name>")
        return
    drug = args[1]
    filepath = get_drug_csv_filepaths(drug)
    raw_tweets = get_raw_tweets(filepath)
    text_analytics_client = TextAnalyticsClient(endpoint=_ENDPOINT, credential=AzureKeyCredential(_KEY))
    sentiments = sentiment_analysis(text_analytics_client, raw_tweets)
    print(f'{drug} sentiment results: {sentiments}')

if __name__ == "__main__":
    main(sys.argv)