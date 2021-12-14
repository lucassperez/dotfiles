#!/bin/sh

# https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/pulseaudio-microphone

status() {
  MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
  vol=$(pacmd list-sources | grep "\* index:" -A 7 | grep volume | awk -F/ '{print $2}' | tr -d ' ')

  if [ "$MUTED" = "yes" ]; then
    echo "%{F#d6ce6f} $vol"
  else
    echo "%{F#d6ce6f} $vol"
  fi
}

listen() {
    status

    LANG=EN; pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
            status
        fi
    done
}

toggle() {
  MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
  DEFAULT_SOURCE=$(pacmd list-sources | awk '/\*/,EOF {print $3; exit}')

  if [ "$MUTED" = "yes" ]; then
      pactl set-source-mute "$DEFAULT_SOURCE" 0
  else
      pactl set-source-mute "$DEFAULT_SOURCE" 1
  fi
}

increase() {
  DEFAULT_SOURCE=$(pacmd list-sources | awk '/\*/,EOF {print $3; exit}')
  pactl set-source-volume "$DEFAULT_SOURCE" +${1:-5}%
}

decrease() {
  DEFAULT_SOURCE=$(pacmd list-sources | awk '/\*/,EOF {print $3; exit}')
  pactl set-source-volume "$DEFAULT_SOURCE" -${1:-5}%
}

set_exact() {
  DEFAULT_SOURCE=$(pacmd list-sources | awk '/\*/,EOF {print $3; exit}')
  pactl set-source-volume "$DEFAULT_SOURCE" ${1:-50}%
}

case "$1" in
    --toggle)
        toggle
        ;;
    --increase)
        increase "$2"
        ;;
    --decrease)
        decrease "$2"
        ;;
    --set)
        set_exact "$2"
        ;;
    *)
        listen
        ;;
esac
