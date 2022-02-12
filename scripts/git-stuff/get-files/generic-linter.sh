#!/bin/sh

##############################
# Name: generic-linter.sh
# Author: Lucas Perez
# Date: 11/12/2021
# Last Update: 11/12/2021
#
# Description: Tries to determine the language of current project and finds
#              files present in the diff with either main or master branch.
#              These files' names are printed to stdout and the lint command is
#              copied to the clipboard. This script is intended to be used
#              outside a docker contianer so that we can just move inside the
#              container and paste the command.
#              If the FIRST argument passed is the string `noclipboard`, then
#              nothing will be copied to the clipboard. This option is intended
#              to be used with some scripts that wants to pipe results into
#              somewhere else, for instance, with VTR (vim plugin).
#              Other arguments will be passed to the linter.
#              Supported languages for now:
#              - Ruby with rubocop
#              - Elixir with credo
#              If the language is ruby, it will try rubocop, even if it is not
#              used in the project.
#
# Usage: sh generic-linter.sh [OPTIONS]
#
# Exit codes:
#   0 - If successfully finds either main or master git branch
#   1 - If not in a git repository
#   2 - If neither git branch main nor master is found
#   3 - If no matching files were found in the diff
#   4 - If project language is not supported
##############################

if [ "$1" = noclipboard ]; then
  NO_CLIP=true
  shift
fi

if [ ! "$(git rev-parse --git-dir 2> /dev/null)" ]; then
  echo Not in a git repository
  exit 1
fi

PROJECT_LANGUAGE=$(sh "$HOME/scripts/git-stuff/get-project-lang.sh")

if [ "$PROJECT_LANGUAGE" = ruby ]; then
  GREP_PATTERN='\.rb$'
  LINTER_COMMAND='bundle exec rubocop'
elif [ "$PROJECT_LANGUAGE" = elixir ]; then
  GREP_PATTERN='\.exs?$'
  LINTER_COMMAND='mix format --check-formatted && mix credo --strict'
else
  echo Language "$LANG" is not supported
  exit 4
fi

ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master ]; then
  [ "$NO_CLIP" ] || echo Current branch is "\e[91;1m$ACTUAL_BRANCH\e[0m"
  FILES=$(git diff "$ACTUAL_BRANCH" --name-only | sort -u | grep -E "$GREP_PATTERN")
elif [ "$(git rev-parse --verify -q main)" ]; then
  FILES=$(git diff main --name-only | sort -u | grep -E "$GREP_PATTERN")
elif [ "$(git rev-parse --verify -q master)" ]; then
  FILES=$(git diff master --name-only | sort -u | grep -E "$GREP_PATTERN")
else
  echo Neither main nor master git branches found
  exit 2
fi

[ -z "$FILES" ] && exit 3

if [ "$NO_CLIP" ]; then
  echo "$LINTER_COMMAND" "$@" $FILES
  exit
fi

for f in $FILES; do
  echo $f
done

echo "$LINTER_COMMAND" "$@" $FILES | xclip -selection clipboard -rmlastnl
