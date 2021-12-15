#!/bin/sh

if [ "$1" = increase ]; then
  # if $2 is not giving, default to 5
  delta=${2:-5}
  xbacklight -inc "$delta"
  polybar-msg hook brightness 1

elif [ "$1" = decrease ]; then
  delta=${2:-5}
  xbacklight -dec "$delta"
  polybar-msg hook brightness 1

elif [ "$1" = set ]; then
  value=${2:-25}
  xbacklight -set "$value"
  polybar-msg hook brightness 1

elif [ "$1" = icon ]; then
  brightness=$(xbacklight -get | cut -d '.' -f 1)
  echo "%{F#aaeb6a} $brightness%"
fi
