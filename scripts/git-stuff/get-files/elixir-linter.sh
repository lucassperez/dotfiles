#!/bin/sh

##############################
# Name: elixir-linter.sh
# Author: Lucas Perez
# Date: 11/12/2021
# Last Update: 11/12/2021
#
# Description: Finds all the .ex and .exs files that have been modified in
#              comparison to main or master branch, prints them
#              in the screen and copies them to the clipboard,
#              prepended with "mix credo --strict".
#              It is meant to be run in the terminal and then you
#              can go to a docker container and simply paste it
#              to run rubocop in all changed files.
#              If the FIRST argument is exactly `noclipboard`, the results will
#              be printed out prepended with the usual "mix credo --strict".
#              This option only exists to run this command from inside vim and
#              pipe the results to some running docker container without having
#              to go through the hassle of copying, changing pane and pasting.
#
# Usage: sh elixir-linter.sh [OPTIONS]
#
# Exit codes:
#   0 - If successfully finds either main or master git branch
#   1 - If not in a git repository
#   2 - If neither git branch main nor master is found
#   3 - If no matching files were found in the diff
##############################

if [ "$1" = noclipboard ]; then
  NO_CLIP=true
  shift
fi

if [ ! "$(git rev-parse --git-dir 2> /dev/null)" ]; then
  echo Not in a git repository
  exit 1
fi

ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master ]; then
  [ "$NO_CLIP" ] || echo -e Current branch is "\e[91;1m$ACTUAL_BRANCH\e[0m"
  FILES=$(git diff "$ACTUAL_BRANCH" --name-only | sort -u | grep -E '\.exs?$')
elif [ "$(git rev-parse --verify -q main)" ]; then
  FILES=$(git diff main --name-only | sort -u | grep -E '\.exs?$')
elif [ "$(git rev-parse --verify -q master)" ]; then
  FILES=$(git diff master --name-only | sort -u | grep -E '\.exs?$')
else
  echo Neither main nor master git branches found
  exit 2
fi

[ -z "$FILES" ] && exit 3

if [ "$NO_CLIP" ]; then
  echo mix credo --strict "$@" $FILES
  exit
fi

for f in $FILES; do
  echo $f
done

echo mix credo --strict "$@" $FILES | xclip -selection clipboard -rmlastnl
