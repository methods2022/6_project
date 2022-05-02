using TextAnalysis
using Pkg
using PyCall  
using VaderSentiment
using TextModels
using Plots
vs =  VaderSentiment.SentimentIntensityAnalyzer    
 
@pyimport nltk.tag as ptag
#@pyimport nltk.sentiment as senti


const txtanalysis = TextAnalysis
const txtmodels = TextModels
const plotter = Plots

function process_tweet(tweet_string)
    Sd = StringDocument(lowercase(tweet_string))
    txtanalysis.prepare!(Sd, strip_corrupt_utf8| strip_punctuation| strip_numbers| strip_stopwords| strip_articles| strip_indefinite_articles| strip_prepositions)
    return txtanalysis.text(Sd)
end

# Vader will output a pos, neg and neut score (sums up to 1)
function sentiment_analysis_vader(string)
    processed_tweet = process_tweet(string)
    dict_results = vs(processed_tweet).polarity_scores
    
    return dict_results
end

# The SentimentAnalyzer outputs a sccore between 0 and 1 and is trained on IMDB reviews.
function sentiment_analysis_sentimentanalyzer(string)
    sa = txtmodels.SentimentAnalyzer()
    processed_tweet = process_tweet(string)
    sd_processed_tweet = StringDocument(processed_tweet)
    return sa(sd_processed_tweet)

end

# Using Julia's TextAnalysis package.
function sentiment_analysis_textanalysis(string)
    processed_tweet = process_tweet(string)
    sd_processed_tweet = StringDocument(processed_tweet)

    # This allows us to have each word as a separate token
    tokens = txtanalysis.tokens(sd_processed_tweet)

    # This allows us to create an n_gram of all the word frequencies
    ngrams_dict = txtanalysis.ngrams(sd_processed_tweet)

    # bar chart that plots the frequency of the words
    plotter.bar(collect(keys(ngrams_dict)),collect(values(ngrams_dict)),orientation=:horizontal)
    plotter.savefig("/gpfs/data/biol1555/darberko/1_code/plot_1.png")

    return 0

end



#print(process_tweet("This is a BOOK AND IT IS BAD"))
#println(sentiment_analysis_vader("This is a BOOK AND IT IS BAD"))
#println(sentiment_analysis_sentimentanalyzer("This is a BOOK AND IT IS BAD"))
println(sentiment_analysis_textanalysis("This drug makes me feel bad. I do not like this drug, I feel bad. I feel very good with this drug. I cannot take this anymore."))
