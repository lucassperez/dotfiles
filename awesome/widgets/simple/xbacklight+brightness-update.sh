#!/bin/sh

xbacklight "$@"
awesome-client "require('widgets.simple.brightness'):update_widget('xbacklight')"
