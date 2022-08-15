#!/bin/sh

_XSET_CONFIGS='220 25'

echo "xset r rate $_XSET_CONFIGS"
xset r rate $_XSET_CONFIGS

[ -f "$HOME/.Xmodmap" ] && echo 'xmodmap ~/.Xmodmap' && xmodmap "$HOME/.Xmodmap"
