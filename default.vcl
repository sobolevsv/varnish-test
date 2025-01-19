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
        unset beresp.http.Cache-Control;
        set beresp.http.Cache-Control = "no-cache, no-store, max-age=0, must-revalidate";
        set beresp.ttl = 0s;
        set beresp.uncacheable = true;
    }

    if (beresp.ttl <= 0s) {
        set beresp.ttl = 86400s;
    }
    return (deliver);
}
