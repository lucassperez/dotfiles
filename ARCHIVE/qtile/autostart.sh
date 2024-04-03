#!/bin/sh

FILE="$HOME/autostart-log-qtile"
echo '`date` ESTOU NO AUTOSTART'>>$FILE

xset r rate 220 25
xset s off
xset -dpms
numlockx on

dunst &
nm-applet &
# Not working?
# ERROR: Can't lock session file -- is another clipmenud running?
# clipmenud &

"$HOME/scripts/killall-and-start/flameshot.sh"
"$HOME/scripts/killall-and-start/unclutter.sh"
"$HOME/scripts/killall-and-start/xplugd.sh"

xcompmgr -c -l0 -t0 -r0 -o.00 &

notify-send 'hello' 'estou dentro do autostart.sh'
