
## Installation

To setup a bbrf server with Docker, simply run the following command

```
sudo docker run -p 5984:5984 -e COUCHDB_USER=<...> -e COUCHDB_PASSWORD=<...> -e BBRF_PASSWORD=<...> honoki/bbrf-server
```

You can specify your own `BBRF_PASSWORD` or remove it to have one automatically generated:

```bash
pieter@ferox:~$ sudo docker run -p 5984:5984 -e COUCHDB_USER=myadmin -e COUCHDB_PASSWORD=mypassword honoki/bbrf-server
[BBRF] Created following password for user bbrf: 6f761a8554744d0883a0772bf73647cb8ebb61633609c45fba048fd9436de6c4
[BBRF] Initialization complete
```

