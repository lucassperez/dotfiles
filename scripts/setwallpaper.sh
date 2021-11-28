#!/bin/sh

[ "$@" ] && [ -f "$@" ] && \
  xwallpaper --zoom "$@" || \
  xwallpaper --zoom "$HOME/Pictures/wallpapers/wall.jpg"
