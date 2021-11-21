#!/bin/sh

##############################
# Name: git-log-main-master.sh
# Author: Lucas Perez
# Date: 03/10/2021
#
# Description: Prints all the commits from main (or master) to HEAD
#              If a main branch is found, it uses main. Else, it looks
#              for a master branch.
#              Any arguments passed to it are going to be used as an argument
#              for the git log command, eg, --oneline, -15 etc.
#
# Usage: sh git-log-main-master.sh [OPTIONS]
#
# Exit codes:
#   0 - If successfully finds either main or master git branch
#   1 - If not in a git repository
#   2 - If neither git branch main nor master is found
##############################

if [ ! "$(git rev-parse --git-dir 2> /dev/null)" ]; then
  echo Not in a git repository

  exit 1
fi

ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master ]; then
  echo Currently at branch "\e[91;1m$ACTUAL_BRANCH\e[0m", executing the command "\e[1mgit log -15 $@\e[0m"
  git log -15 "$@"
  exit 0

elif [ "$(git rev-parse --verify -q main)" ]; then
  BRANCH=main

elif [ "$(git rev-parse --verify -q master)" ]; then
  BRANCH=master

else
  echo Neither main nor master git branches found

  exit 2
fi

git log "$BRANCH"^..HEAD "$@"
