#!/bin/sh

touchpad_device_name="`xinput --list --name-only | grep -i "touchpad" | head -n 1`"
[ -n "$touchpad_device_name" ] || exit

enabled=`xinput list-props "$touchpad_device_name" | grep 'Device Enabled' | awk '{print $4}'`
[ -n "$enabled" ] || exit

# touchpad_device_id=$(xinput --list | grep -i 'touchpad' | sed 's/.*id=\([0-9]\+\).*/\1/' | head -n 1) || exit
# enabled=`xinput list-props $touchpad_device_id | grep 'Device Enabled' | awk '{print $4}'`

if [ $enabled = 1 ]; then
  enabled=yes
else
  enabled=no
fi

if [ $enabled = yes ]; then
  xinput disable "$touchpad_device_name"
  status="DISABLED"
else
  xinput enable "$touchpad_device_name"
  status="ENABLED"
fi

notify-send "Touchpad $status" "Device $touchpad_device_name"
