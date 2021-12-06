#!/bin/sh

# Number of docker containers running
count=$(docker ps -q | wc -l)
# Recent docker container IP
# recent_ip=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $(docker ps -ql))

if [ "$BLOCK_BUTTON" = 1 -o "$BLOCK_BUTTON" = 3 ]; then
  if [ "$count" -gt 0 ]; then
    x=$(docker ps | tail -n +2 | head -1)
    y=$(echo "$x" | sed 's/.* \(\w*$\)/\1/')
    notify-send -u low -i "$HOME/.config/i3/blocklets-scripts/icon-docker.png" 'Dockers' "$y"
  else
    notify-send -u low -i "$HOME/.config/i3/blocklets-scripts/icon-docker.png" 'Dockers' 'No containers running'
  fi
fi

echo "$LABEL $count"
