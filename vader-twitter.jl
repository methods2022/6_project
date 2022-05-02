using VaderSentiment
analyzer = VaderSentiment.SentimentIntensityAnalyzer

function main() 
    str_list = String["zoloft", "cymblata", "pristiq", "celexa", "viibryd"]
    drug_dict = Dict()
    size = length(str_list)
    sum_neg = 0.0
    sum_neu = 0.0
    sum_pos = 0.0
    sum_compound = 0.0

    # compute the average of the values in 100 dictionaries
    for i in 1:size
        vs = analyzer(str_list[i]).polarity_scores
        sum_neg += vs["neg"]
        sum_neu += vs["neu"]
        sum_pos += vs["pos"]
        sum_compound += vs["compound"]
    end 

    average_neg = sum_neg / size
    average_neu = sum_neu / size
    average_pos = sum_pos / size

    average_compound = sum_compound / size
end

main()