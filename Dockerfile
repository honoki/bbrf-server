FROM couchdb:3.1.1

ADD https://raw.githubusercontent.com/honoki/bbrf-server/main/couchdb/views.json /tmp/
ADD https://raw.githubusercontent.com/honoki/bbrf-server/main/couchdb/docker-entrypoint.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/honoki/bbrf-server/main/couchdb/bbrf-init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
	chmod +x /usr/local/bin/bbrf-init.sh

RUN apt-get install -y curl
