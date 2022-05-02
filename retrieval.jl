import Dates

using HTTP
using JSON

function create_TA2C_from_file(filename::String = ".keys")::Dict
    keys = Dict()
  
    isfile(filename) || exit("File not found: " + filename)
  
    open(filename) do f
        for line in eachline(f)
            line = strip(line)
            array = split(line, "=")
            keys[array[1]] = strip(array[2])
        end
    end

    return keys
end

function make_GET_req(url, body, TA2c)
    header = ["Authorization"=>"Bearer "* TA2c["token"], "User-Agent"=>"Twitter-API-sample-code"]
    return HTTP.request("GET", url, header, query=body)
end

function store_raw_data(drug_name, folder, date, url, body, TA2c)
    filename = folder*drug_name*date
    http_response = make_GET_req(url, body, TA2c)
    json_data = JSON.parse(String(http_response.body))
    open(filename,"w") do f 
        JSON.print(f, json_data)
    end
end

zoloft_query = Dict(
    "query"=>"zoloft",
    "tweet.fields"=>"author_id",
    "max_results"=>100,
)
cymbalta_query = Dict(
    "query"=>"cymbalta",
    "tweet.fields"=>"author_id",
    "max_results"=>100,
)
pristiq_query = Dict(
    "query"=>"pristiq",
    "tweet.fields"=>"author_id",
    "max_results"=>100,
)
celexa_query = Dict(
    "query"=>"celexa",
    "tweet.fields"=>"author_id",
    "max_results"=>100,
)
viibryd_query = Dict(
    "query"=>"viibryd",
    "tweet.fields"=>"author_id",
    "max_results"=>100
)
TA2c = create_TA2C_from_file()
search_url = "https://api.twitter.com/2/tweets/search/recent"
date = String(Dates.format(Dates.now(), "y-m-d"))
folder = "raw-data/"


store_raw_data("zoloft-", folder, date, search_url, zoloft_query, TA2c)
store_raw_data("cymbalta-", folder, date, search_url, cymbalta_query, TA2c)
store_raw_data("pristiq-", folder, date, search_url, pristiq_query, TA2c)
store_raw_data("celexa-", folder, date, search_url, celexa_query, TA2c)
store_raw_data("viibryd-", folder, date, search_url, viibryd_query, TA2c)