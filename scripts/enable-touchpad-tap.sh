#!/bin/sh

echo To be fair, it is probably better to activate this
echo at the file /usr/share/X11/xorg.conf.d/40-libinput.conf,
echo using the Option \"Tapping\" \"on\", and while at that,
echo probably also put Option \"NaturalScrolling\" \"True\".
echo
echo Yes, you have to type Option. It should be something like this:
echo
echo 'Section "InputClass"'
echo '        Identifier "libinput touchpad catchall"'
echo '        MatchIsTouchpad "on"'
echo '        MatchDevicePath "/dev/input/event*"'
echo '        Driver "libinput"'
echo '        Option "Tapping" "on"'
echo '        Option "NaturalScrolling" "True"'
echo 'EndSection'

# if [ "$#" = 0 ]; then
#   touchpad_device_name=$(xinput --list --name-only | grep -i "touchpad" | head -n 1) || exit
# else
#   touchpad_device_name="$1"
# fi

# printf "Using $touchpad_device_name as the touchpad device's name.\n"
# xinput set-prop "$touchpad_device_name" "libinput Tapping Enabled" 1
