#!/bin/sh

##############################
# Name: get-files-rspec.sh
# Author: Lucas Perez
# Date: 11/10/2021
#
# Description: Finds all files inside the spec folder that ends
#              with _spec.rb and have been modified in comparison
#              to the main or master branch, prints them in the
#              screen and copies them to the clipboard, prepended
#              with "bundle exec rspec".
#              It is meant to be run in the terminal and then you
#              can go to a docker container and simply paste it
#              to run rspec in all changed files.
#
# Usage: sh get-files-rspec.sh [OPTIONS]
#
# Exit codes:
#   0 - If successfully finds either main or master git branch
#   1 - If not in a git repository
#   2 - If neither git branch main nor master is found
#   3 - If no matching files were found in the diff
##############################

if [ ! "$(git rev-parse --git-dir 2> /dev/null)" ]; then
  echo Not in a git repository
  exit 1
fi

ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master ]; then

  echo Current branch is "\e[91;1m$ACTUAL_BRANCH\e[0m"
  FILES=$(git diff "$ACTUAL_BRANCH" --name-only | sort -u | grep -E 'spec.*_spec\.rb$')

elif [ "$(git rev-parse --verify -q main)" ]; then

  FILES=$(git diff main --name-only | sort -u | grep -E 'spec.*_spec\.rb$')

elif [ "$(git rev-parse --verify -q master)" ]; then

  FILES=$(git diff master --name-only | sort -u | grep -E 'spec.*_spec\.rb$')

else
  echo Neither main nor master git branches found
  exit 2
fi

[ -z "$FILES" ] && exit 3

for f in $FILES; do
  echo $f
done

echo bundle exec rspec "$@" $FILES | xclip -selection clipboard -rmlastnl
