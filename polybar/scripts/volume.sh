#!/bin/sh

# 1 = left click, 2 = scroll click, 3 = right click
# 4 = scroll up, 5 = scroll down
# case $BLOCK_BUTTON in
if [ "$1" = toggle ]; then
  amixer -D pulse sset Master toggle
  polybar-msg hook volume 1

elif [ "$1" = increase ]; then
  # if $2 is not giving, default to 5
  delta=${2:-5}
  amixer -D pulse sset Master $delta%+
  polybar-msg hook volume 1

elif [ "$1" = decrease ]; then
  delta=${2:-5}
  amixer -D pulse sset Master $delta%-
  polybar-msg hook volume 1

elif [ "$1" = set ]; then
  amount=${2:-50}
  amixer -D pulse sset Master $amount%
  polybar-msg hook volume 1

elif [ "$1" = icon ]; then
  AUDIO_HIGH_SYMBOL=' '
  AUDIO_MED_SYMBOL=' '
  AUDIO_LOW_SYMBOL=' '
  AUDIO_MUTED_SYMBOL='X'

  INFO=$(amixer -D pulse sget Master | grep -s 'Front Left:' | tr -d '[]%')
  if [ -z "$INFO" ]; then
    INFO=$(amixer -D pulse sget Master | grep -s 'Mono:' | tr -d '[]%')
    volume=$(echo "$INFO" | cut -d ' ' -f 6)
  else
    volume=$(echo "$INFO" | cut -d ' ' -f 7)
  fi
  is_mute=$(echo "$INFO" | cut -d ' ' -f 8)

  # `is_mute` is either `on` or `off` for not muted and muted, respectively
  if [ "$is_mute" = off ]; then
    icon="$AUDIO_MUTED_SYMBOL"

  elif [ "$volume" -ge 50 ]; then
    icon="$AUDIO_HIGH_SYMBOL"

  elif [ "$volume" -gt 0 ]; then
    icon="$AUDIO_MED_SYMBOL"

  else
    icon="$AUDIO_LOW_SYMBOL"
  fi

  echo "%{F#d986c0}$icon $volume%"
fi
