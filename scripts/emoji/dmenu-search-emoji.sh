#!/bin/sh

# A file named "simple-list" is in the same folder as this script, so to avoid
# passing big paths around, we just do this
THIS_SCRIPTS_DIR_NAME=$(dirname "$0")

# Opens dmenu so we can search for emojis, case insensitive
DMENU_OPTS='-i -l 15 -p EMOJIS -h 21'
SELECTION=$(cat "$THIS_SCRIPTS_DIR_NAME/simple-list" | dmenu $DMENU_OPTS -sb "#008080")

# If nothing is selected, we just exit with this guard clause to avoid messing
# with the clipboard and notifications
[ "$SELECTION" ] || exit

# Get only the emoji and put it in clipboard
echo "$SELECTION" | cut -d ' ' -f 1 | xclip -selection clipboard -rmlastnl

notify-send -u low --expire-time=1500 "$(xclip -out -selection clipboard) copied to clipboard"

# Print the name of the emoji, in case this is being run from command line
# Maybe it would be more useful to return the emoji itself, but anyways
echo $(echo "$SELECTION" | cut -d ' ' -f 2-)
