vcl 4.1;

backend default {
    .host = "nginx";
    .port = "80";
}

sub vcl_recv {
    if (req.method == "BAN") {
        ban("obj.http.url ~ " + req.url);
        return(synth(200, "Ban added for " + req.url));
    }
    return (hash);
}

sub vcl_backend_response {
    set beresp.http.url = bereq.url;

    if (beresp.http.Cache-Control ~ "no-cache") {
        set beresp.uncacheable = true;
        set beresp.ttl = 86400s;
    }

    return (deliver);
}
