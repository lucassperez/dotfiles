#!/bin/sh

# 1 = left click, 2 = scroll click, 3 = right click
# 4 = scroll up, 5 = scroll down
case $BLOCK_BUTTON in
  1|3) pactl set-sink-mute   @DEFAULT_SINK@ toggle ;;
  2)   pactl set-sink-volume @DEFAULT_SINK@ 100% ;;
  4)   pactl set-sink-volume @DEFAULT_SINK@ +2% ;;
  5)   pactl set-sink-volume @DEFAULT_SINK@ -2% ;;
esac

AUDIO_HIGH_SYMBOL=${AUDIO_HIGH_SYMBOL:-'  '}

AUDIO_MED_THRESH=${AUDIO_MED_THRESH:-50}
AUDIO_MED_SYMBOL=${AUDIO_MED_SYMBOL:-'  '}

AUDIO_LOW_THRESH=${AUDIO_LOW_THRESH:-0}
AUDIO_LOW_SYMBOL=${AUDIO_LOW_SYMBOL:-'  '}

AUDIO_MUTED_SYMBOL=${AUDIO_MUTED_SYMBOL:-'X '}

INFO=$(amixer sget Master | grep -s 'Front Left:' | tr -d '[]%')
is_mute=$(echo "$INFO" | cut -d ' ' -f 8)
volume=$(echo "$INFO" | cut -d ' ' -f 7)

# `is_mute` is either `on` or `off` for not muted and muted, respectively
if [ "$is_mute" = off ]; then
  printf "$AUDIO_MUTED_SYMBOL"
elif [ "$volume" -gt "$AUDIO_MED_THRESH" ]; then
  printf "$AUDIO_HIGH_SYMBOL"
elif [ "$volume" -gt "$AUDIO_LOW_THRESH" ]; then
  printf "$AUDIO_MED_SYMBOL"
else
  printf "$AUDIO_LOW_SYMBOL"
fi

echo "$volume%"
