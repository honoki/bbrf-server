#!/bin/bash

sleep 10

COUCHDB=http://localhost:5984/
AUTH=$COUCHDB_USER:$COUCHDB_PASSWORD

if [ -z "$BBRF_PASSWORD" ]; then
    BBRF_PASSWORD=$(openssl rand -hex 32)
    echo "[BBRF] Created following password for user bbrf: $BBRF_PASSWORD"
fi

# create the _users db
curl -X PUT $COUCHDB"_users" -u $AUTH -s > /dev/null

# create the bbrf user
curl -X PUT -X PUT $COUCHDB"/_users/org.couchdb.user:bbrf" -u $AUTH \
     -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -d '{"name": "bbrf", "password": "'$BBRF_PASSWORD'", "roles": [], "type": "user"}' -s > /dev/null

# create a new database called bbf
curl -X PUT $COUCHDB"bbrf" -u $AUTH -s > /dev/null

# grant access rights to the new database
curl -X PUT $COUCHDB"bbrf/_security" -u $AUTH -d "{\"admins\": {\"names\": [\"bbrf\"],\"roles\": []}, \"members\": {\"names\": [\"bbrf\"],\"roles\": []}}" -s > /dev/null

# push bbrf views
curl -X PUT $COUCHDB"bbrf/_design/bbrf" -u $AUTH -H "Content-Type: application/json" -d @/tmp/views.json -s > /dev/null

# enable CORS
curl -X PUT $COUCHDB"_node/_local/_config/httpd/enable_cors" -u $AUTH -d '"true"' -s > /dev/null

# allow origin from dashboard on https://bbrf.me
curl -X PUT $COUCHDB"_node/_local/_config/cors/origins" -u $AUTH -d '"https://bbrf.me"' -s > /dev/null
curl -X PUT $COUCHDB"_node/_local/_config/cors/credentials" -u $AUTH -d '"true"' -s > /dev/null

echo "[BBRF] Initialization complete"
