Group 6 Directory - Methods 2022

The following directory explores our research, which asks if and how Twitter data can be analyzed to quantify patient sentiment towards antidepressants. We use Twitter’s API to extract user-provided data and then different sentiment analysis packages to quantify patient perception of the 5 most commonly prescribed ntidepressants.

**Packages Required**
  
    Python:
        - sys
        - matplotlib.pyplot
        - pandas
        - numpy
        - vaderSentiment
        - azure.core.credentials, AzureKeyCredential
        - azure.ai.textanalytics, TextAnalyticsClient
        
    Julia:
        - StatsPlots
        - PyPlot
        - PyCall
        - VaderSentiment
        - HTTP
        - JSON
        - CSV
        - DataFrames
        - TextAnalysis
    

**Retrieval**

In order to run the retrieval scripts, please first set up your [Twitter API account](https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api). Paste your Bearer Token in the retrieval.jl or retrieval_academic_access.jl. Depending on your access permssion, run one  of the following through terminal:

```
julia retrieval.jl

julia retrieval_academic_access.jl
```

These files will retrieve the raw tweets for each  antidepressant and store them in the raw-data directory.


**Processing**

Next, run the following script:

```
julia preprocess.jl
```

This will read all the raw twitter data files,  standardize them, and store them accordingly for each antidepressant as text file under the data directory. 

**Analysis**

For the sentiment  analysis, we choose to use Azure's Text Analytics Service and NLTK (VADER). For the former, [first create your account and service endpoint in Azure](https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/quickstart?pivots=programming-language-python#code-example). Next, update the endpoint and key variables in  the sentiment_analysis_azure.py. Next, run the followings to conduct the sentiment analysis:

```
python3 sentiment_analysis_azure.py

python3 sentiment_analysis_nltk.py

julia sentiment_analysis_vader.jl
```

Each script will use their corresponding packages to run sentiment analysis on the data. They will then output the polarity results for each drug in a new text file under the visualization directory. 

**Visualization**

Once the analysis output have successfully been saved, run  the following  scripts to generate the visualizations of the sentiment analysis results for each package:

```
julia visualzation_azure.jl

julia visualzation_nltk.jl

julia visualzation_vader.jl
```

Each script will create a save a series of visualizations with the results of the sentiment analysis for each antidepressant under the visualization directory.

________________________________________________________________________________________________________________________________________________________

**Notebooks**: Under this directory, you can find our exploratory code that was used to get a better understanding of Julia and Python, especially its different packages.

