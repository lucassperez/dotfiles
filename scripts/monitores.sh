#!/bin/sh

help_message() {
  echo 'As opções são:'
  echo 't | top    (monitor acima)'
  echo 'r | right  (monitor à direita)'
  echo 'b | bot    (monitor abaixo)'
  echo 'l | left   (monitor à esquerda)'
  echo 's | single (um único monitor)'
  echo 'S | same   (mesma coisa nas duas telas)'
  echo 'Qualquer outra coisa mostra essa mensagem de ajuda.'
}

if [ "$#" -eq 0 ]; then
  help_message
  exit 1
fi

for arg in $@; do
  case "$arg" in
    top|t)
      position='--above'
      ;;
    right|r)
      position='--right-of'
      ;;
    bot|b)
      position='--below'
      ;;
    left|l)
      position='--left-of'
      ;;
    single|s)
      xrandr --auto --output eDP-1 --mode 1920x1080 --primary
      . "$HOME/scripts/setwallpaper.sh"
      exit
      ;;
    same|S)
      if xrandr --listactivemonitors | grep -v "Monitors: 1"; then
        echo 'Only one monitor active, exiting without doing anything.'
        exit
      fi
      xrandr --auto --output eDP-1 --mode 1920x1080
      xrandr --auto --output HDMI-1 --mode 1920x1080 --primary
      xrandr --output HDMI-1 --same-as eDP-1
      echo 'Had to set eDP-1 resolution to 1920x1080, because otherwise it would look weird.'
      . "$HOME/scripts/setwallpaper.sh"
      exit
      ;;
    *)
      help_message
      exit 1
      ;;
  esac
done

xrandr --auto --output eDP-1  --mode 1920x1080
xrandr --auto --output HDMI-1 --mode 1920x1080 "$position" eDP-1 --primary

# Why not (re)set wallpaper as well? It might have bugged the zoom
. "$HOME/scripts/setwallpaper.sh"
