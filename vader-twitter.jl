using VaderSentiment
analyzer = VaderSentiment.SentimentIntensityAnalyzer


function process_input(input_filename)
    input_file = open(input_filename, "r")
    line_count = 0
    all_tweets = []

    for line in eachline(input_file)
        # skip first line - header 
        line_count += 1
        if line_count == 1
            continue
        end
        
        # split line
        line_part_array = split(line,"|")

        # retrieve processed tweet
        push!(all_tweets, line_part_array[3])
    end 
    close(input_file)
    return all_tweets
end 


function iterate_over_all_drugs(output_filename)
    data_folder = "data/"
    data_text_paths = ["zoloft.txt", "cymbalta.txt", "pristiq.txt", "celexa.txt", "viibryd.txt"]

    output_file = open(output_filename, "w")
    for data_path in data_text_paths
        input_path = data_folder*data_path
        tweets = process_input(input_path)
        score = analyze(tweets)
        drug_name = split(data_path, ".")[1]
        write(output_file, "$drug_name score: $score\n")
    end
    close(output_file)
end 

# analyses the strings (tweets)
function analyze(str_list) 
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
    return average_compound
end


# puts everything together
iterate_over_all_drugs("vader_julia_output.txt")
# analyze(process_input("twitter-example.txt")) - for testing 