using StatsPlots

VISUALIZATION_DIR = "visualization/"
VISUALIZATION_ANALYSIS_FILE = "visualization/vader_analysis_output.txt"

# Sources for references: https://github.com/goropikari/PlotsGallery.jl

##get $sum_pos|$sum_neu|$sum_neg|$sum_compound from the output txt
# "drug|size|sum_neg|sum_neu|sum_pos|sum_compound\n"
function process_input(input_filename, drugs)
    input_file = open(input_filename, "r")
    line_count = 0

    sizes = Dict()

    for line in eachline(input_file)
        list_for_this_drug = []
        # skip first line - header 
        line_count += 1
        if line_count == 1
            continue
        end
        # split line
        line_part_array = split(line,"|")

        push!(list_for_this_drug, parse(Float64, line_part_array[5])) # pos 
        push!(list_for_this_drug, parse(Float64, line_part_array[3])) # neg 
        push!(list_for_this_drug, parse(Float64, line_part_array[4])) # neu 
        push!(list_for_this_drug, parse(Float64, line_part_array[6])) # compound 

        drugs[line_part_array[1]] = list_for_this_drug
        sizes[line_part_array[1]] = parse(Int, line_part_array[2])
    end 
    close(input_file)

    return sizes, [drugs["zoloft"] drugs["cymbalta"] drugs["celexa"] drugs["viibryd"] drugs["pristiq"]], drugs 
end 


# drug list: 2D matrix where there is a list of all the counts of 
#   zoloft, cymbalta, celexa, viibryd, pristiq in that order
# makes a bar plot and writes it to some file 
function make_bar_plot(drug_list) 
    # Creating a stacked barplot to display the counts of sentiments for each drug
    ticklabel = ["Positive Tweets", "Negative Tweets", "Neutral Tweets", "Mixed Sentiment Tweets"]
    groupedbar(drug_list,
            bar_position = :stack,
            bar_width=0.7,
            xticks=(1:4, ticklabel),
            label=["zoloft" "cymbalta" "celexa" "viibryd" "pristiq"])
    
    savefig(VISUALIZATION_DIR*"/vader_barplot.png")
end 


# given a list of counts and size of tweets, make a list of percentages 
function make_percentages(counts, size)
    new_list = []

    for i in counts
        push!(new_list, i/size)
    end 

    return new_list 
end 


# Creating pie charts
function make_pie_plot(sizes, drugs)
    sentiments = ["Positive Tweets", "Negative Tweets", "Neutral Tweets", "Mixed Sentiment Tweets"]

    pie(sentiments, make_percentages(drugs["zoloft"], sizes["zoloft"]))
    savefig(VISUALIZATION_DIR*"/vader_zoloft_piechart.png")

    pie(sentiments, make_percentages(drugs["cymbalta"], sizes["cymbalta"]))
    savefig(VISUALIZATION_DIR*"/vader_cymbalta_piechart.png")

    pie(sentiments, make_percentages(drugs["celexa"], sizes["celexa"]))
    savefig(VISUALIZATION_DIR*"/vader_celexa_piechart.png")

    pie(sentiments, make_percentages(drugs["viibryd"], sizes["viibryd"]))
    savefig(VISUALIZATION_DIR*"/vader_viibryd_piechart.png")

    pie(sentiments, make_percentages(drugs["pristiq"], sizes["pristiq"]))
    savefig(VISUALIZATION_DIR*"/vader_pristiq_piechart.png")
end 


function main()
    sizes, drugs_list_for_graph, drugs_dict = process_input(VISUALIZATION_ANALYSIS_FILE, Dict())
    make_bar_plot(drugs_list_for_graph)
    make_pie_plot(sizes, drugs_dict)
end

main()
