#!/bin/sh

selected=$(cat ~/scripts/tmux-chtsh/tmux-cht-languages ~/scripts/tmux-chtsh/tmux-cht-command | fzf)

printf "\e[1mSelected:\e[0m \e[33m%s\e[0m\n" "$selected"
printf "\e[1mQuery:\e[0m \e[32m"
read -r query

if grep -qs "$selected" ~/scripts/tmux-chtsh/tmux-cht-languages; then
    query=$(echo "$query" | tr ' ' '+')
    tmux neww bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
fi
