#!/bin/sh

infos=$(acpi --battery)

state=$(echo "$infos" | sed 's/Battery [0-9]: \(\w*\).*/\1/')
percentage=$(echo "$infos" | sed 's/Battery [0-9]: \w*, \([0-9]*\)%.*/\1/')
hours_mins_left=$(echo "$infos" | sed 's/Battery [0-9]: \w*, [0-9]*%, \([0-9][0-9]:[0-9][0-9]\).*/\1/')

# Define icons based on state and percentage
if [ "$state" = Charging ]; then
  icons="%{F#ff0}%{F-}"
elif [ "$state" = Discharging ]; then
  if [ "$percentage" -gt 80 ]; then
    icons=' '
  elif [ "$percentage" -gt 60 ]; then
    icons=' '
  elif [ "$percentage" -gt 40 ]; then
    icons=' '
  elif [ "$percentage" -gt 20 ]; then
    icons=' '
  else
    icons=' '
  fi
else
  icons=''
fi

# Define colors based on percentage
if [ "$percentage" -le 10 ]; then
  color="%{F#ffffff}%{B#ff0000}"
elif [ "$percentage" -le 20 ]; then
  color="%{F#ff3300}"
elif [ "$percentage" -le 30 ]; then
  color="%{F#ff6600}"
elif [ "$percentage" -le 40 ]; then
  color="%{F#ff9900}"
elif [ "$percentage" -le 50 ]; then
  color="%{F#ffcc00}"
elif [ "$percentage" -le 60 ]; then
  color="%{F#ffff00}"
elif [ "$percentage" -le 70 ]; then
  color="%{F#ffff33}"
elif [ "$percentage" -le 80 ]; then
  color="%{F#ffff66}"
else
  color="%{F#ffffff}"
fi

# Make the percentage always ocupy 3 characters by padding white spaces
# Also, if battery is charging and at 98%, show 100%
if [ "$percentage" -ge 98 -a "$state" = Charging ]; then
  final="$icons${color}100%"
elif [ "$percentage" -eq 100 ]; then
  final="$icons${color}100%"
elif [ "$percentage" -ge 10 ]; then
  final="$icons${color} $percentage%"
else
  final="$icons%{F-}  $percentage%"
fi

echo "$final"
