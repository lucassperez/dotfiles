#!/bin/sh

# emoji=`rofimoji --action print --prompt 'Emoji'`
emoji=`rofimoji --action print --prompt '(<S-CR>) Emoji' --skin-tone neutral`

[ -z $emoji ] && exit

echo $emoji | xclip -selection clipboard -rmlastnl
notify-send -u low --expire-time=1500 "$emoji copied to clipboard!" "\t\t\t\t\tRofi"
