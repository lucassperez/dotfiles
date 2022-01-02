#!/bin/sh

if [ "$#" = 0 ]; then
  touchpad_device_name=$(xinput --list --name-only | grep -i "touchpad") || exit
else
  touchpad_device_name="$1"
fi

printf "Using $touchpad_device_name as the touchpad device's name.\n"
xinput set-prop "$touchpad_device_name" "libinput Tapping Enabled" 1
