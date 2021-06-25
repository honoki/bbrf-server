# create a self-signed certificate for nginx reverse proxy
mkdir -p /etc/nginx/
openssl genrsa > /etc/nginx/privkey.pem
openssl req -new -x509 -key /etc/nginx/privkey.pem -out /etc/nginx/cert.pem -days 1095 -subj "/C=BE/ST=BBRF/L=BBRF/O=BBRF/CN=bbrf-server"