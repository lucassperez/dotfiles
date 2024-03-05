#!/bin/sh

touchpad_id=`xinput --list | grep -i 'touchpad' | head -n 1 | sed 's|.*id=\([0-9]\+\).*|\1|'`
[ -n "$touchpad_id" ] || exit

enabled=`xinput list-props "$touchpad_id" | awk '/Device Enabled \([0-9]+\):\s*[01]/ {print $4}'`
[ -n "$enabled" ] || exit

if [ $enabled = 1 ]; then
  enabled=yes
else
  enabled=no
fi

if [ $enabled = yes ]; then
  xinput disable "$touchpad_id"
  status="DISABLED"
else
  xinput enable "$touchpad_id"
  status="ENABLED"
fi

touchpad_device_name=`
  xinput --list \
  | grep id=$touchpad_id \
  | sed "s|^[^0-9a-zA-Z]*\(.*)*\)\s*id=$touchpad_id.*|\1|" \
  | sed 's|\s*$||' \
  `

notify-send "Touchpad $status" "Device ${touchpad_device_name:-with id $touchpad_id}"
