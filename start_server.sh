#!/usr/bin/env bash
DIR=$(cd "$(dirname "$0")"; pwd)

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

rm -rf selenzyme
mkdir selenzyme
wget http://130.88.113.226/selenzy/selenzy.tar.gz
tar -xzvf selenzy.tar.gz -C selenzyme

docker build -t selenzyme .

docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

docker run --name selenzyme -d -p :5000 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -e VIRTUAL_HOST=selenzyme.synbiochem.co.uk -v=$DIR/selenzyme:/selenzyme selenzyme