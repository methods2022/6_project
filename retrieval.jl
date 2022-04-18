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

TA2c = create_TA2C_from_file()

function make_GET_req(url, body)
    header = ["Authorization"=>"Bearer "* TA2c["token"], "User-Agent"=>"Twitter-API-sample-code"]
    return HTTP.request("GET", url, header, query=body)
end

query_params = Dict(
    "query"=>"zoloft",
    "tweet.fields"=>"author_id"
)
search_url = "https://api.twitter.com/2/tweets/search/recent"

http_r = make_GET_req(search_url, query_params)

print(http_r.status)
print(String(http_r.body))
