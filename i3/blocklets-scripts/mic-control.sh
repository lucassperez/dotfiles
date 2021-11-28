#!/bin/sh

# 1 = left click, 2 = scroll click, 3 = right click
# 4 = scroll up, 5 = scroll down
# alsa_input.pci-0000_00_1f.3.analog-stereo
case $BLOCK_BUTTON in
  1|2|3) pactl set-source-mute "$SOURCE" toggle ;;
  4) pactl set-source-volume "$SOURCE" +2.5% ;;
  5) pactl set-source-volume "$SOURCE" -2.5% ;;
esac

infos=$(pacmd list-sources | grep -A 11 "$SOURCE")
volume=$(echo "$infos" | awk '/volume: front-left:/ {print $5}')
is_muted=$(echo "$infos" | awk '/muted/ {print $2; exit}')

if [ "$is_muted" = yes ]; then
  echo " $volume"
else
  echo " $volume"
fi
