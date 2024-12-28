# DevopsENV
This project provides a docker image with a set of useful tools.

## Build DevopsENV
docker build . -t devopsenv:1.0

## Run DevopsENV
docker run --name devops1 -it --rm -v ${PWD}/tmp:/tmp -v ${PWD}/workspace:/root/workspace devopsenv:1.0

## Run by using compose
docker-compose up -d
docker-compose exec devops bash