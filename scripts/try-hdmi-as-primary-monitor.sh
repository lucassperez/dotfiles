#!/bin/sh

xrandr_output=`xrandr | grep 'HDMI-\?1'`

if echo $xrandr_output | grep -q 'HDMI-\?1 connected'; then
  output_name=`echo $xrandr_output | cut -d ' ' -f 1`
  xrandr --output $output_name --primary
fi
