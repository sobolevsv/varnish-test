#!/bin/bash

url="http://127.0.0.1:6081/product-detail-page2"

# Number of requests
count=1000


for i in $(seq 1 $count); do
    # Generate a random User-Agent
    user_agent="Test-Agent-$i"

    # Send the request and ignore the response output
    curl -s -o /dev/null -w "Request $i: HTTP Status Code: %{http_code}, User-Agent: $user_agent\n" -A "$user_agent" "$url"
done
