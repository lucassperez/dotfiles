#!/bin/sh

case $BLOCK_BUTTON in
  # 1|2|3|4|5) notify-send "MAX TURBO" "MEGA NITRO" ;;
  1|2|3|4|5) /bin/env lua /home/lucas/dotfiles/i3/blocklets-scripts/turbo.lua ;;
esac

echo TURBO
