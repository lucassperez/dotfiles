#!/bin/sh

if [ "$BLOCK_BUTTON" = 1 -o "$BLOCK_BUTTON" = 3 ]; then
  output=$(ps axh -o cmd,%mem --sort=-%mem | head -15)
  notify-send -u low 'Maiores consumos de memória' "$output"
fi

free -h | awk '/^Mem:/ {print " "$3}'
