#!/bin/sh

pavucontrol "$@"
awesome-client "require('widgets.simple.volume'):update_widget()"
awesome-client "require('widgets.simple.microphone'):update_widget()"
