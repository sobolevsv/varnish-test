# Varnish Cache performance issue

This repository demonstrates a Varnish performance issue described in https://github.com/varnishcache/varnish-cache/pull/4236

Start Varnish and Nginx as a backend
```bash
docker-compose up -d
```

Send 1000 requests with unique User-Agent
```
send_requests.sh
```

Send 10k bans
```
send_bans.sh
```

Now Varnish is prepared, next request will result in 1000*10k=10M ban-object tests

```bash
curl --location 'http://127.0.0.1:6081/product2' --header 'User-Agent: test1'
```
On my laptop it take 2 seconds.
if the number of bans increases to 100k, then it takes 25 seconds
