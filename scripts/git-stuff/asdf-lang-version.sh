#!/bin/sh

lang=$(. ~/scripts/git-stuff/get-project-lang.sh)

# [ "$lang" ] || exit 100

# asdf current "$lang" 2>/dev/null | awk '{print $1" "$2}'

# asdf current "$lang" 2>/dev/null | sed 's/\(\w\+\)\s*\(\S*\).*/\1 \2/'

asdf_output=$(asdf current "$lang" 2>/dev/null)
echo ${asdf_output%%/*}
