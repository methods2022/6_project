import JSON
using TextAnalysis
using CSV
using DataFrames

const txtanalysis = TextAnalysis

raw_data_folder = "raw-data/"
data_folder = "data/"
drug_list = ["zoloft", "cymbalta", "celexa", "viibryd"] #TODO: add "pristiq".
raw_data_filepaths = Dict(
    "zoloft"=>[],
    "cymbalta"=>[],
    "pristiq"=>[],
    "celexa"=>[],
    "viibryd"=>[]
)
data_text_outputpaths = Dict(
    "zoloft"=>"zoloft.txt",
    "cymbalta"=>"cymbalta.txt",
    "pristiq"=>"pristiq.txt",
    "celexa"=>"celexa.txt",
    "viibryd"=>"viibryd.txt"
)

function get_raw_data_filepaths(drug_string, raw_folder, dict)
    files = readdir(abspath(raw_folder), join=true)
    for file in files
        if occursin(drug_string, file)
            push!(dict[drug_string], file)
        end
    end 
end

function process_tweet(tweet_string)
    Sd = StringDocument(lowercase(tweet_string))
    txtanalysis.prepare!(Sd, strip_corrupt_utf8| strip_punctuation| strip_numbers| strip_stopwords| strip_articles| strip_indefinite_articles| strip_prepositions)
    return text(Sd)
end

function prepare_for_print(s)
    s =  replace(s, "|"=>"")
    s = replace(s, "\n"=>"")
    return s
end

function parse_to_textfile(drug_string, raw_datafilepath_list, data_folder)
    header = "count|raw_tweet|processed_tweet\n"
    output_file = data_folder*data_text_outputpaths[drug_string]
    open(output_file, "w") do file
        write(file, header)
        for input_file in raw_datafilepath_list
            s = read("$input_file", String)
            j = JSON.parse(s)
            count = 1
            for data in j["data"]
                raw_tweet = prepare_for_print(data["text"])
                processed_tweet = prepare_for_print(process_tweet(raw_tweet))
                storage = "$count|$raw_tweet|$processed_tweet\n"
                write(file, storage)
                count = count + 1
            end
        end
    end
end


function convert_to_csv(drug_string, data_folder)
    filename = data_folder*data_text_outputpaths[drug_string]
    input_fh = open(filename, "r")
    b_df = CSV.File(input_fh, header=1, footerskip=0, delim="|") |> DataFrame
    CSV.write(data_folder*drug_string*".csv", b_df)
    close(input_fh)
end


for drug in drug_list
    get_raw_data_filepaths(drug, raw_data_folder, raw_data_filepaths)
    parse_to_textfile(drug, raw_data_filepaths[drug], data_folder)
    convert_to_csv(drug, data_folder)
end
