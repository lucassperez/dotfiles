#!/bin/sh

alacritty -t floating-alacritty -o window.opacity=1.0 -e pulsemixer
awesome-client "require('widgets.simple.volume'):update_widget()"
awesome-client "require('widgets.simple.microphone'):update_widget()"
