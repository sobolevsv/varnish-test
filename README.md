# Varnish Cache performance issue

This repository demonstrates a Varnish performance issue described in https://github.com/varnishcache/varnish-cache/pull/4236

Start Varnish and Nginx as a backend
```bash
docker-compose up -d
```

Send 1000 requests with unique User-Agent
```
./send_requests.sh
```

Send 10k bans
```
./send_bans.sh
```

Now Varnish is prepared, next request will result in 1000*10k=10M ban-object tests

```bash
time curl --location 'http://127.0.0.1:6081/product-detail-page2' --header 'User-Agent: Test-Agent-1000'
```
On my laptop it takes 2 seconds.
if the number of bans increases to 100k, then it takes 25 seconds


To check current ban list
```bash
docker exec -it varnish-cache varnishadm ban.list
```

## How is this solved in Varnish 7.7
This issue can be resolved by setting **ban_any_variant=0** in Varnish 7.7
Repeat the same steps as above, but with docker-compose-7.7.yml
This file runs Varnish 7.7 with ban_any_variant=0

```bash
docker-compose down

docker-compose -f docker-compose-7.7.yml up -d

./send_requests.sh

./send_bans.sh

time curl --location 'http://127.0.0.1:6081/product-detail-page2' 
--header 'User-Agent: Test-Agent-1000'
```
Now, even with 100 thousand bans, the response time is a fraction of a second


It is planned to set **ban_any_variant** to 0 in version 8.0.
https://github.com/varnishcache/varnish-cache/issues/3352