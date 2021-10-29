[![Docker Pulls](https://img.shields.io/docker/pulls/honoki/bbrf-server?style=flat-square)](https://hub.docker.com/r/honoki/bbrf-server)
[![Twitter Follow](https://img.shields.io/twitter/follow/honoki?style=flat-square)](https://twitter.com/honoki)
    
## Introduction

The Bug Bounty Reconnaissance Framework (BBRF) is intended to facilitate the workflows of security researchers across multiple devices. This repository contains the source files to deploy a BBRF server. 

For more information about BBRF, read the blog post on https://honoki.net/2020/10/08/introducing-bbrf-yet-another-bug-bounty-reconnaissance-framework/

Once you have deployed a BBRF server, move on to [install the BBRF client here](https://github.com/honoki/bbrf-client/)

## Installation

Start by cloning this repository:

```bash
git clone https://github.com/honoki/bbrf-server/
cd bbrf-server
```

Next, make the required changes to the `docker-compose.yml` by which I mean CHANGE THE DEFAULT PASSWORDS FOR THE LOVE OF GOD!

And finally, run

```bash
sudo docker-compose up -d
```

Note that this will expose port 443 (https) on your BBRF server to the internet. Docker Compose generates a self-signed certificate for the reverse proxy which it persists to the volume `./keys/`. You can replace them with a valid certificate if you want to avoid certificate warnings, see the instructions below.

Verify your installation by browsing to https://127.0.0.1/_utils/#database/bbrf/_all_docs

## Generate certificate with Letsencrypt

To configure your BBRF server with a valid certificate, it suffices to generate the cert files with `certbot` and place them in the `keys` directory. The keys will be picked up when you next start the containers.

The following steps should get you up and running:

1. Ensure you have a domain name pointed to your BBRF server;
2. If you are still in docker-compose, stop the containers with `ctrl+C`;
3. Install certbot: `sudo apt install certbot`
4. If necessary, allow HTTP traffic e.g: `ufw allow 80/tcp`
5. Run `certbot -d yourdomain.com certonly` and follow the steps;
6. Copy the generated certificate files to the keys volume: `cp /etc/letsencrypt/live/yourdomain.com/{fullchain.pem,privkey.pem} ./proxy/keys/`
7. Restart your containers: `sudo docker-compose up -d`

Browse to `https://yourdomain.com/_utils/#database/bbrf/_all_docs` to validate the setup.
