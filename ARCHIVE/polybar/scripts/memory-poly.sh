#!/bin/sh

if [ "$1" = icon ]; then
  free -h | awk '/^Mem:/ {print "%{F#de6347}MEM "$3}'
elif [ "$1" = notify ]; then
  output=$(ps axh -o cmd,%mem --sort=-%mem | head -15)
  notify-send -u low 'Maiores consumos de memória' "$output"
fi
