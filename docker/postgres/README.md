# Creating POSTGRES Development Environment

Starting a complete development environment for postgres.


## Usage
1) Define your environment's parameters by using .env settings file.

2) Create into the folder config/certs the server certification files for nginx with following command:
```shell
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes -keyout server.key -out server.crt -subj '/CN=localhost'
```

3) Spin the evironment with docker compose:

```shell
# Starting the development environment
docker-compose up -d 
```