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

# https://stackoverflow.com/questions/37351664/colors-in-dash-not-bash
ACTUAL_BRANCH=$(git branch --show-current)
if [ "$ACTUAL_BRANCH" = main -o "$ACTUAL_BRANCH" = master -o "$ACTUAL_BRANCH" = develop ]; then
  echo -e Currently at branch "\e[91;1m$ACTUAL_BRANCH\e[0m", executing the command "\e[1mgit log -15 $@\e[0m"
  git log -15 "$@"
  # Just exit to keep the exit code of git log, be it zero or non zero
  exit

elif [ "$(git rev-parse --verify -q develop)" ]; then
  echo -e "\e[1;30;43mTODO\e[0m Remover a branch develop do script, um dia"
  BRANCH=develop

elif [ "$(git rev-parse --verify -q main)" ]; then
  BRANCH=main

elif [ "$(git rev-parse --verify -q master)" ]; then
  BRANCH=master

else
  echo Neither main nor master git branches found

  exit 2
fi

if [ "$(git rev-parse --verify -q "$BRANCH"^)" ]; then
  git log "$BRANCH"^.."$ACTUAL_BRANCH" "$@"
else
  git log "$BRANCH".."$ACTUAL_BRANCH" "$@"
fi
