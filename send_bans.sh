#!/bin/bash

# Base URL of the Varnish server
base_url="http://127.0.0.1:6081/product-detail-page2"


# first ban that erase all hit-for-miss objects
curl -X BAN -s -o /dev/null -w "BAN Request $i: HTTP Status Code: %{http_code}, URL: $base_url\n" "$base_url"

# Total number of BAN requests
total_requests=10000

# Number of threads
threads=100

base_url="http://127.0.0.1:6081/product"

# Function to send a single BAN request
send_request() {
    local i=$1
    local unique_url="${base_url}-${i}"
    curl -X BAN -s -o /dev/null -w "BAN Request $i: HTTP Status Code: %{http_code}, URL: $unique_url\n" "$unique_url"
}

export -f send_request
export base_url

# Generate sequence and process with xargs
seq 1 $total_requests | xargs -n 1 -P $threads -I {} bash -c 'send_request "$@"' _ {}
