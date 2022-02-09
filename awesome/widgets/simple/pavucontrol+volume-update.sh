#!/bin/sh

pavucontrol "$@"
awesome-client "require('widgets.simple.volume'):update_widget('amixer -D pulse sget Master')"
awesome-client "require('widgets.simple.microphone'):update_widget('amixer sget Capture')"
