[![Mastodon](https://img.shields.io/mastodon/follow/110779442452085429?domain=https%3A%2F%2Finfosec.exchange&style=flat-square&logo=mastodon&logoColor=fff)](https://infosec.exchange/@honoki)
[![BlueSky](https://img.shields.io/badge/@honoki.net-0285FA?logo=bluesky&logoColor=fff&style=flat-square)](https://bsky.app/profile/honoki.net)
    
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

**⚠️ IMPORTANT: Change the default passwords!**

Edit the `docker-compose.yml` file and replace the default passwords:
- `COUCHDB_PASSWORD=admin` - Change this to a strong password
- `BBRF_PASSWORD=bbrf` - Change this to a strong password

Build and start the containers:

```bash
sudo docker compose up -d
```

Note that this will expose port 443 (https) on your BBRF server to the internet. Docker Compose generates a self-signed certificate for the reverse proxy which it persists to the volume `./keys/`. You can replace them with a valid certificate if you want to avoid certificate warnings, see the instructions below.

Verify your installation by browsing to https://127.0.0.1/_utils/#database/bbrf/_all_docs

## Generate certificate with Let's Encrypt
To configure your BBRF server with a valid certificate using Caddy, follow these steps:

1. Make sure you have a domain name pointed to your BBRF server.
3. In the `Caddyfile`, set your domain and uncomment these lines:

    ```
    yourdomain.com {
        reverse_proxy couchdb:5984
        encode gzip
        request_body {
            max_size 4GB
        }
    }
    ```

3. Caddy will automatically obtain and renew TLS certificates from Let's Encrypt for your domain.
5. Start or restart your containers:

    ```bash
    sudo docker compose up -d
    ```

Caddy will handle certificate management automatically. You can now access your BBRF server securely at `https://yourdomain.com/_utils/#database/bbrf/_all_docs`.

Browse to `https://yourdomain.com/_utils/#database/bbrf/_all_docs` to validate the setup.

## See also

* [BBRF Client](https://github.com/honoki/bbrf-client)
* [BBRF Dashboard](https://github.com/honoki/bbrf-dashboard)
* [BBRF Burp Plugin](https://github.com/honoki/bbrf-burp-plugin)
* [BBRF Agents](https://github.com/honoki/bbrf-agents)