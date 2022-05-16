using PyPlot

VISUALIZATION_DIR = "visualization/"
VISUALIZATION_ANALYSIS_FILE = "visualization/nltk_analysis_output.txt"

input = open("visualization/nltk_analysis_output.txt", "r")

xlab = ["positive", "negative", "neutral"]

for line in readlines(input)
    
    array = split(line, "|")

    data = [parse(Int, array[2]), parse(Int, array[3]), parse(Int, array[4])]

    drug = array[1]

    b = bar(xlab, data, align="center", color= ["blue","orange","green"],alpha=0.4)
    PyPlot.title("$drug Tweet Sentiment Analysis by NLTK")
    output_file = VISUALIZATION_DIR*"$(drug)_nltk_python.png"

    plt.savefig(output_file)

end
