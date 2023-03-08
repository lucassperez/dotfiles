#!/bin/sh

lang=$(. ~/scripts/git-stuff/get-project-lang.sh)

# [ "$lang" ] || exit 100

rtx_output="$lang $(rtx current "$lang" 2>/dev/null)"
echo $rtx_output
