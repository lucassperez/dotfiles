#!/bin/sh

# Debian 11 has a version with a bug actually. Better to install this version instead:
# sudo apt-get install xwallpaper=0.7.3-1

[ "$@" ] && [ -f "$@" ] && \
  xwallpaper --zoom "$@" || \
  xwallpaper --zoom "$HOME/Pictures/wallpapers/wall.jpg"
