# shared reverse-proxy settings for /ords/ -> ADB managed ORDS
# (mirrors dev-proxy.py: Bearer Authorization passes through untouched;
#  DCT_REST.VALIDATE_SESSION keeps doing the real auth in-DB)
proxy_pass https://$ords_host;
# ORDS emits absolute redirects against the ADB host (e.g. 301 adding a
# trailing slash) - rewrite them back to this origin, or browsers leave the
# domain and drop the Authorization header (dev-proxy masked this by
# following redirects server-side). MUST be the literal host: the variable
# form ($ords_host) silently fails to match (verified on nginx 1.20).
proxy_redirect https://__ORDS_HOST__/ /;
proxy_ssl_server_name on;
proxy_ssl_name $ords_host;
proxy_ssl_protocols TLSv1.2 TLSv1.3;
proxy_set_header Host $ords_host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_connect_timeout 10s;
proxy_send_timeout 60s;
proxy_read_timeout 180s;   # FL AI document extraction on large PDFs (FL dev-proxy parity)
