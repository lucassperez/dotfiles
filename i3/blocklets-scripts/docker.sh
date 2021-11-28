#!/bin/sh

# Number of docker containers running
count=$(docker ps -q | wc -l)
# Recent docker container IP
# recent_ip=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $(docker ps -ql))

echo "$LABEL $count"
