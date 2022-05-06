import os
from azure.core.credentials import AzureKeyCredential
from azure.ai.textanalytics import TextAnalyticsClient

_DRUGS_DIR = 'data/'
_ENDPOINT = '!!!PASTE HERE!!!'
_KEY = '!!!PASTE HERE!!!'
_BATCH_SIZE = 10
_OUTPUT_FILE = 'visualization/azure_analysis_output.txt'

def get_data_filepaths(drug):
    file = drug+".txt"
    return os.path.join(_DRUGS_DIR, file)

def get_raw_tweets(filepath):
    raw_tweets = []
    datafile = open(filepath, 'r')
    for line in datafile.readlines():
        raw_tweet = line.split('|')[1]
        if raw_tweet == "raw_tweet":
            continue
        raw_tweets.append(raw_tweet)
    return raw_tweets

def sentiment_analysis(client, documents):
    size = len(documents)
    sentiments = {
        "negative": 0,
        "positive": 0,
        "neutral":  0,
        "mixed": 0,
        }
    for index in range(0, size, _BATCH_SIZE):
        response = client.analyze_sentiment(documents=documents[index:index+_BATCH_SIZE])
        for doc in response:
            if doc.sentiment not in sentiments:
                sentiments[doc.sentiment] = 0
            sentiments[doc.sentiment] += 1
    return sentiments


def main():
    drug_list = ["zoloft","cymbalta", "celexa", "viibryd", "pristiq"]
    with open(_OUTPUT_FILE, 'w') as f:
        f.write("drug_name|num_of_tweets|num_positive|num_negative|num_neutral|num_mixed\n")
        for drug in drug_list:
            filepath = get_data_filepaths(drug)
            raw_tweets = get_raw_tweets(filepath)
            text_analytics_client = TextAnalyticsClient(endpoint=_ENDPOINT, credential=AzureKeyCredential(_KEY))
            sentiments = sentiment_analysis(text_analytics_client, raw_tweets)
            output = f"{drug}|{len(raw_tweets)}|{sentiments['positive']}|{sentiments['negative']}|{sentiments['neutral']}|{sentiments['mixed']}\n"
            f.write(output)
        

if __name__ == "__main__":
    main()