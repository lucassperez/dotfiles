#!/bin/sh

count=$(docker ps -q | wc -l)

if [ "$1" = icon ]; then
  # Why doesn't this emoji appear? ):
  echo "%{F#0db7ed}🐳 $count"

elif [ "$1" = notify ]; then
  if [ "$count" -gt 0 ]; then
    running_containers=$(docker ps --format "{{.Names}} ({{.RunningFor}})\n")
    notify-send -u low -i "$HOME/.config/i3/blocklets-scripts/icon-docker.png" 'Dockers' "$running_containers"
  else
    notify-send -u low -i "$HOME/.config/i3/blocklets-scripts/icon-docker.png" 'Dockers' 'No containers running'
  fi
fi
