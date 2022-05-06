using PyCall
using PyPlot

VISUALIZATION_DIR = "visualization/"
VISUALIZATION_ANALYSIS_FILE = "visualization/azure_analysis_output.txt"
GRAPH_END_SAVE_NAME = "_azure_piechart.png"

function get_analysis_output(file_in)
    drug_to_nums = Dict()
    drug_to_size = Dict()
    i_file = open(file_in, "r")
    for line in eachline(i_file)
        line_array = split(line, "|")
        if line_array[1] == "drug_name"
            continue
        end
        drug_to_nums[line_array[1]] = line_array[3:6]
        drug_to_size[line_array[1]] = parse(Int32, line_array[2])
    end
    close(i_file)
    return drug_to_nums, drug_to_size
end

drug_to_nums, drug_to_size = get_analysis_output(VISUALIZATION_ANALYSIS_FILE)
drug_list = ["zoloft", "cymbalta", "celexa", "viibryd", "pristiq"]
labels = ["Positive Tweets", "Negative Tweets", "Neutral Tweets", "Mixed Sentiment Tweets"]

for drug in drug_list
    metrics = drug_to_nums[drug]
    total = drug_to_size[drug]
    title = "Azure's Text Analytics Service's sentiment analysis of $total tweets with $drug keyword"
    output_file = VISUALIZATION_DIR*drug*GRAPH_END_SAVE_NAME
    fig = figure(figsize=(10, 10))
    p = pie(metrics, labels=labels, autopct="%1.1f%%")
    axis("equal")
    PyPlot.title(title)
    plt.savefig(output_file)
end