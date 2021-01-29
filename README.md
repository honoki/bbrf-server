
## Introduction

The Bug Bounty Reconnaissance Framework (BBRF) is intended to facilitate the workflows of security researchers across multiple devices. This repository contains the source files to deploy a BBRF server. 

For more information about BBRF, read the blog post on https://honoki.net/2020/10/08/introducing-bbrf-yet-another-bug-bounty-reconnaissance-framework/

Once you have deployed a BBRF server, move on to [install the BBRF client here](https://github.com/honoki/bbrf-client/)

## Installation

### Docker

This is the recommended way to install the BBRF server. Simply run the [preconfigured docker image](https://hub.docker.com/repository/docker/honoki/bbrf-server) to get started:

```
sudo docker run -p 5984:5984 -e COUCHDB_USER=<choose admin username> -e COUCHDB_PASSWORD=<choose admin password> -e BBRF_PASSWORD=<choose bbrf password> honoki/bbrf-server
```

You can specify your own `BBRF_PASSWORD` or remove it to have one automatically generated:

```bash
pieter@ferox:~$ sudo docker run -p 5984:5984 -e COUCHDB_USER=myadmin -e COUCHDB_PASSWORD=mypassword honoki/bbrf-server
[BBRF] Created following password for user bbrf: 6f761a8554744d0883a0772bf73647cb8ebb61633609c45fba048fd9436de6c4
[BBRF] Initialization complete
```

Verify your installation by browsing to http://127.0.0.1:5984/_utils/#database/bbrf/_all_docs 

### Axiom

If you're already using [Axiom](https://github.com/pry0cc/axiom), deploying is made very easy thanks to @pry0cc

```bash
# to deploy a new instance and auto deploy bbrf server:
axiom-init bbrf --deploy=bbrf
# to deploy on an existing box:
axiom-deploy bbrf <your instance name>
```

### Manual installation

To manually install a CouchDB server and configure it as a BBRF server, this is what you need to do:

* Deploy the [CouchDB image from Bitnami](https://aws.amazon.com/marketplace/pp/B01M0RA8RQ?ref=cns_srchrow) from the AWS Marketplace or using docker:
    ```bash
    curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-couchdb/master/docker-compose.yml > docker-compose.yml
    docker-compose up -d
    ```
* My current setup runs on a `t3a.small` tier in AWS and seems to effortlessly support 116 thousand documents at the time of writing;
* I strongly suggest enabling (only) https on your server;
* When up and running, browse to the web interface on `https://<your-instance>:6984/_utils/#/_all_dbs` and check if everything's OK
* Create the `bbrf` user (additional documentation [here](https://docs.couchdb.org/en/stable/intro/security.html)) via curl:

    ```bash
    COUCHDB=https://<yourinstance>:6984/
    
    curl -X PUT $COUCHDB"_users" \
         -u admin:password
         
    curl -X PUT curl -X PUT $COUCHDB"/_users/org.couchdb.user:bbrf" \
         -u admin:password \
         -H "Accept: application/json" \
         -H "Content-Type: application/json" \
         -d '{"name": "bbrf", "password": "<choose a decent password>", "roles": [], "type": "user"}'
    ```

* Create a new database called `bbrf`:

    ```bash
    curl -X PUT $COUCHDB"bbrf" \
         -u admin:password
    ```

* Grant access rights to the new database:
    ```bash
    curl -X PUT $COUCHDB"bbrf/_security" \
         -u admin:password \
         -d "{\"admins\": {\"names\": [\"bbrf\"],\"roles\": []}}"
    ```

* Download [views.json](views.json) and configure the required views via curl:
    ```bash
    curl -X PUT $COUCHDB"bbrf/_design/bbrf" \
         -u admin:password \
         -H "Content-Type: application/json" \
         -d @views.json
    ```
    
* Allow CORS requests from https://bbrf.me to use the dashboard:
    ```bash
    curl -X PUT $COUCHDB"_node/_local/_config/httpd/enable_cors"
         -u admin:password \
         -d '"true"'
    curl -X PUT $COUCHDB"_node/_local/_config/cors/origins" \
         -u admin:password \
         -d '"https://bbrf.me"'
    curl -X PUT $COUCHDB"_node/_local/_config/cors/credentials" \
         -u admin:password \
         -d '"true"'
    ```
