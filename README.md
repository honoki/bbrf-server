[![Docker Pulls](https://img.shields.io/docker/pulls/honoki/bbrf-server?style=flat-square)](https://hub.docker.com/r/honoki/bbrf-server)
[![Twitter Follow](https://img.shields.io/twitter/follow/honoki?style=flat-square)](https://twitter.com/honoki)
    
## Introduction

The Bug Bounty Reconnaissance Framework (BBRF) is intended to facilitate the workflows of security researchers across multiple devices. This repository contains the source files to deploy a BBRF server. 

For more information about BBRF, read the blog post on https://honoki.net/2020/10/08/introducing-bbrf-yet-another-bug-bounty-reconnaissance-framework/

Once you have deployed a BBRF server, move on to [install the BBRF client here](https://github.com/honoki/bbrf-client/)

## Installation

Simply clone this repository:

```bash
git clone https://github.com/honoki/bbrf-server/
cd bbrf-server
```

Make the required changes to the `docker-compose.yml` by which I mean CHANGE THE DEFAULT PASSWORDS FOR THE LOVE OF GOD!

```yml
version: "3.9"
services:
  couchdb:
    image: honoki/bbrf-server
    environment:
      - COUCHDB_USER=admin
      - COUCHDB_PASSWORD=<your super secure admin password>
      - BBRF_PASSWORD=<another super secure password>
  proxy:
    image: nginx
    ports:
     - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
      - ./docker-entrypoint.d/:/docker-entrypoint.d/
    depends_on:
      - couchdb
```

and run

```bash
sudo docker-compose up
```

Note that this will expose port 443 (https) on your BBRF server to the internet. Docker Compose generates a self-signed certificate for the reverse proxy which it stores in `/etc/nginx/`. You can replace them with "valid" certificates manually if you want to avoid certificate warnings.

Verify your installation by browsing to https://127.0.0.1/_utils/#database/bbrf/_all_docs 