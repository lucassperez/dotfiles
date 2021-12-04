#!/bin/sh

# There is also the `cal` cli tool, very nice. Might be able
# to redirect its output to dunst or something?
# gsimplecal is similar to zenity but with not buttons

DATE_FORMAT=${DATE_FORMAT:-'+%a, %d/%b/%y'}

[ "$BLOCK_BUTTON" ] && zenity --calendar --text= >/dev/null

date "$DATE_FORMAT"
