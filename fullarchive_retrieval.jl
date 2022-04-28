import Dates

using HTTP
using JSON

zoloft_query = Dict(
    "query"=>"zoloft",
    "tweet.fields"=>"author_id"
)
cymbalta_query = Dict(
    "query"=>"cymbalta",
    "tweet.fields"=>"author_id"
)
pristiq_query = Dict(
    "query"=>"pristiq",
    "tweet.fields"=>"author_id"
)
celexa_query = Dict(
    "query"=>"celexa",
    "tweet.fields"=>"author_id"
)
viibryd_query = Dict(
    "query"=>"viibryd",
    "tweet.fields"=>"author_id"
)
search_url = "https://api.twitter.com/2/tweets/search/all"
storage = "fullarchive"
folder = "raw-data/"

function process_token(s)
    keys = Dict()
    keys["token"] = strip(s)
    return keys
end

function make_GET_req(url, body, TA2c)
    header = ["Authorization"=>"Bearer "* TA2c["token"], "User-Agent"=>"Twitter-API-sample-code"]
    return HTTP.request("GET", url, header, query=body)
end

function store_raw_data(drug_name, folder, storage, url, body, TA2c)
    filename = folder*drug_name*storage
    http_response = make_GET_req(url, body, TA2c)
    json_data = JSON.parse(String(http_response.body))
    open(filename,"w") do f 
        JSON.print(f, json_data)
    end
end

println("PLEASE ENTER BEARER TOKEN: ")
TA2c = process_token(readline(stdin))
store_raw_data("zoloft-", folder, storage, search_url, zoloft_query, TA2c)
store_raw_data("cymbalta-", folder, storage, search_url, cymbalta_query, TA2c)
store_raw_data("pristiq-", folder, storage, search_url, pristiq_query, TA2c)
store_raw_data("celexa-", folder, storage, search_url, celexa_query, TA2c)
store_raw_data("viibryd-", folder, storage, search_url, viibryd_query, TA2c)