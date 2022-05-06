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
    write(output_file, "drug|size|sum_neg|sum_neu|sum_pos|sum_compound\n")
    for data_path in data_text_paths
        input_path = data_folder*data_path
        tweets = process_input(input_path)
        size, sum_neg, sum_neu, sum_pos, sum_compound = analyze(tweets)
        drug = split(data_path, ".")[1]
        write(output_file, "$drug|$size|$sum_neg|$sum_neu|$sum_pos|$sum_compound\n")
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
    for i in 1:size
        vs = analyzer(str_list[i]).polarity_scores
        sum_neg += vs["neg"]
        sum_neu += vs["neu"]
        sum_pos += vs["pos"]
        sum_compound += vs["compound"]
    end
    return size, sum_neg, sum_neu, sum_pos, sum_compound
end

iterate_over_all_drugs("visualization/vader_anaylsis_output.txt")