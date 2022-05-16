using StatsPlots

VISUALIZATION_ANALYSIS_FILE = "visualization/nltk_analysis_output.txt"

input = open("visualization/nltk_analysis_output.txt", "r")

drugs = ["zoloft", "cymbalta", "celexa", "viibryd", "pristiq"]
xlab = ["positive", "negative", "neutral"]

data = Dict()

for line in eachline(input)
    
    array = split(line, "|")
    data[array[1]] = [parse(Int, array[2]), parse(Int, array[3]), parse(Int, array[4])]

end

for drug in drugs

    values = data[drug]

    bar(values, xticks=(1:3, xlab), color = [:blue, :orange, :green])
    savefig("visualization/$(drug)_nltk_python.png")

end
