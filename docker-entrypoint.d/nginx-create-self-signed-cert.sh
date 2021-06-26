# create a self-signed certificate for nginx reverse proxy
# but only if it doesn't exist yet
if [ ! -f "/etc/nginx/keys/privkey.pem" ]; then
    mkdir -p /etc/nginx/keys/
    openssl genrsa > /etc/nginx/keys/privkey.pem
    openssl req -new -x509 -key /etc/nginx/keys/privkey.pem -out /etc/nginx/keys/cert.pem -days 1095 -subj "/C=BE/ST=BBRF/L=BBRF/O=BBRF/CN=bbrf-server"
fi