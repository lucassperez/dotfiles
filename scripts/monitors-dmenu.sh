#!/bin/sh

script_path="$HOME/scripts/monitores.sh"

if ! [ -x "$script_path" ]; then
  echo "Monitor script not found in $script_path"
  exit 2
fi

# options="left\ntop\nright\nbot\nsingle"
options="right\nbot\nleft\ntop\nsingle\nwallpaper\nsame screen on both monitors"

arg=$( \
  printf $options | \
    dmenu \
    -h 21 \
    -p "(Monitores) Escolha a posição" \
    -sb "#008080" \
    -nb "#000000" \
)

if [ -z $arg ] || [ $arg = q -o $arg = Q ]; then
  exit
fi

if [ $arg = w -o $arg = wallpaper ]; then
  "$HOME/scripts/setwallpaper.sh"
  exit
fi

if echo $arg | grep -qv '\(^l$\|^t$\|^r$\|^b$\|^s$\|^left$\|^top$\|^right$\|^bot$\|^single$\)'; then
  echo "Opção inválida: $arg"
  exit 1
fi

$script_path $arg
