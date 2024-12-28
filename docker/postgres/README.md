# Creating POSTGRES Development Environment

Starting a development environment for postgres.

## Setup
1) Define the environment's parameters by using __.env__ properties file:
```
ENV_NAME=<<environment-name>>

NGINX_RELEASE= 1.21
NGINX_HOSTPORT=8081

POSTGRES_RELEASE=17.2
POSTGRES_USER=<<postgres-user>>
POSTGRES_PASSWORD=<<postgres-password>>
POSTGRES_DB=<<postgres-db>>

PGADMIN_RELEASE=latest
PGADMIN_EMAIL=<<pgadmin-user>>
PGADMIN_PASSWORD=<<pgadmin-password>>
```

2) Create into the folder config/certs the server certification files for nginx with following command:
```shell
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes -keyout server.key -out ./config/certs/server.crt -subj '/CN=localhost'
```

3) Spin up the evironment with docker compose:

```shell
# Starting the development environment
docker compose --env-file path/to/your/.env up -d 
```