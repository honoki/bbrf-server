FROM couchdb:3.5.0

COPY couchdb/views.json /tmp/
COPY couchdb/docker-entrypoint.sh /usr/local/bin/
COPY couchdb/bbrf-init.sh /usr/local/bin/

RUN apt-get install -y curl