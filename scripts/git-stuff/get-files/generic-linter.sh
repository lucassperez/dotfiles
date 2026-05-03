#!/bin/sh

##############################
# Name: generic-linter.sh
# Author: Lucas Perez
# Date: 11/12/2021
# Last Update: 11/12/2021
# Last Update: 02/05/2026
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
#              This script uses xclip to copy the output to the clipboard, so
#              you will need to have it installed everytime it is ran without
#              the `noclipboard` option.
#
# Usage: sh generic-linter.sh [OPTIONS]
#
# Exit codes:
#   0 - If successfully finds either main or master git branch
#   1 - If not in a git repository
#   2 - If neither git branch main nor master is found
#   3 - If no matching files were found in the diff
#   4 - If project language is not supported
#   5 - If project language could not be determined
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
elif [ -z "$PROJECT_LANGUAGE" ]; then
  echo Language of project could not be determined
  exit 5
else
  echo Language "$PROJECT_LANGUAGE" is not supported
  exit 4
fi

git_diff_ls_files() {
  echo "`git diff $1 --name-only`\n`git ls-files --exclude-standard --others`"
}

ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master -o "$ACTUAL_BRANCH" = develop ]; then
  [ "$NO_CLIP" ] || echo Current branch is "\e[91;1m$ACTUAL_BRANCH\e[0m"
  FILES=$(git_diff_ls_files "$ACTUAL_BRANCH" | sort -u | grep -E "$GREP_PATTERN")
elif [ "$(git rev-parse --verify -q develop)" ]; then
  FILES=$(git_diff_ls_files develop | sort -u | grep -E "$GREP_PATTERN")
elif [ "$(git rev-parse --verify -q main)" ]; then
  FILES=$(git_diff_ls_files main | sort -u | grep -E "$GREP_PATTERN")
elif [ "$(git rev-parse --verify -q master)" ]; then
  FILES=$(git_diff_ls_files master | sort -u | grep -E "$GREP_PATTERN")
else
  echo Neither main nor master nor develop git branches found
  exit 2
fi

[ -z "$FILES" ] && exit 3

if [ "$NO_CLIP" ]; then
  echo "$LINTER_COMMAND" "$@" $FILES
  exit
fi

for f in "$FILES"; do
  echo "$f"
done

echo "$LINTER_COMMAND" "$@" $FILES | xclip -selection clipboard -rmlastnl
