#!/bin/sh

all_sessions=$(tmux ls) || exit

OLDIFS="$IFS"
IFS='
'
for session in $(echo "$all_sessions"); do
  name=${session%%:*}
  rest=$(echo "$session" | cut -d ' ' -f 2-)
  final=$(echo $rest | sed -E 's/(^[0-9] windows?) .*\((created [a-zA-Z]{3} [a-zA-Z]{3} [0-9]{1,2} [0-9]{1,2}:[0-9]{2}:[0-9]{2} [0-9]{4})\)(.*)/ \\e[0;1m\1 \\e[0;95m[\2]\\e[91m\3\\e[0m/')
  printf "\e[33m$name\e[0m:$final\n"
done
IFS="$OLDIFS"
