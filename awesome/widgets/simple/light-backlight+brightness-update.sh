#!/bin/sh

light "$@"
awesome-client "require('widgets.simple.brightness'):update_widget('light')"
