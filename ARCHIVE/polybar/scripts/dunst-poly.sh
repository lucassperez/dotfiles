#!/bin/sh

if [ "$1" = toggle ]; then
  dunstctl set-paused toggle
  polybar-msg hook dunst 1
elif [ "$1" = icon ]; then
  if [ "$(dunstctl is-paused)" = true ]; then
    echo "%{F#BE616E}"
  else
    echo "%{F#A4B98E}"
  fi
fi

