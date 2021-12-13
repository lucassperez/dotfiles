#!/bin/sh

# 1 = left click, 2 = scroll click, 3 = right click
# 4 = scroll up, 5 = scroll down
#
SOURCE=alsa_input.pci-0000_00_1f.3.analog-stereo

# When pactl is used, the volume control goes crazy and increases and decreases
# by a f***ing lot, instead of just 2%.

# case "$BLOCK_BUTTON" in
#   1|2) pactl set-source-mute "$SOURCE" toggle ;;
#   3)   pavucontrol ;;
#   4)   pactl set-source-volume "$SOURCE" +2 ;;
#   5)   pactl set-source-volume "$SOURCE" -2 ;;
# esac

# When amixer is used, it increases by 3% instead of 2%, why
case "$BLOCK_BUTTON" in
  1|2) amixer sset Capture toggle >/dev/null ;;
  3)   pavucontrol && pkill -RTMIN+11 i3blocks && pkill -RTMIN+10 i3blocks;;
  4)   amixer sset Capture 2%+ >/dev/null ;;
  5)   amixer sset Capture 2%- >/dev/null ;;
esac

# infos=$(pacmd list-sources | grep -A 11 "$SOURCE")
# volume=$(echo "$infos" | awk '/volume: front-left:/ {print $5}')
# is_muted=$(echo "$infos" | awk '/muted/ {print $2; exit}')

# infos will be something like [30%][on],
# which corresponds to the volume and state
infos=$(amixer get Capture | awk '/Front (Left|Right):/ {print $5 $7}' | head -1)
volume=$(echo "$infos" | sed 's/^\[\([0-9]\+%\)\].*$/\1/')

# if [ "$is_muted" = yes ]; then
if echo "$infos" | grep off >/dev/null ; then
  printf ""
else
  printf ""
fi

echo " $volume"
