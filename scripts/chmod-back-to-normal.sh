#!/bin/sh

# Author: Lucas Perez
# Feel free to use and distribute this script as you please (:

# chmod -x all regular files and chmod 755 all directories inside current directory
# if the script is called with the `recursive` option, it also goes inside directories
# and executes itself recursively. PROCEED WITH CAUTION.
# This script is also going to remove execute permissions from scripts that should
# have executing permissions because it just checks if it is a regular file.
# This script does NOT go inside git directories.
# This script does NOT touch symbolic links.
# This script may or may not handle well files and directories with spaces on their names ):

# Usage examples:
# sh chmod-back-to-normal.sh [OPTIONS]
# Available options:
# -r: Executes the script recursively (going inside directories)
# -a: Executes the script on hidden files/directories as well (will execute ls -A to find files and directories)
# -q: Executes the script but does not print messages to stdout
# -f: Does not ask for confirmation
# -h: will show the help message
# --help: same as -h

show_help_message() {
  echo -e Usage: sh chmod-back-to-normal [OPTIONS]
  echo
  echo -e This script is intended to run '\e[1m'chmod -x'\e[0m' on all regular files
  echo -e and '\e[1m'chmod 755'\e[0m' on all directories found inside current directory.
  echo -e Note that this script '\e[1m'will remove execute permissions'\e[0m' from all regular
  echo -e files it finds, including scripts that should have those permissions.
  echo -e Symbolic links are ignored.
  echo -e This script may or may not handle very well files and directories with
  echo -e spaces on their names '):'
  echo
  echo -e OPTIONS
  echo
  echo -e '  -r\t\t'Executes the script recursively, going inside found directories.
  echo -e '\t\t'This script will '\e[1m'NOT'\e[0m' go inside git directories,
  echo -e '\t\t'but will work if called from inside one.
  echo -e '\t\t'This script does not go inside the '\e[1m'.git'\e[0m' directory
  echo -e '\t\t'itself unless called from inside it.
  echo -e '  -a\t\t'Executes the script on hidden files/directories as well.
  echo -e '\t\t'It will execute ls -a to find files and directories.
  echo -e '  -q\t\t'Does not print anything to stdout.
  echo -e '  -f\t\t'Does not ask for confirmation.
  echo -e '  -h, --help\t'Shows this help message.
}

reexecutes_recursively() {
  cd "$target"
  if [ "$(git rev-parse --git-dir 2> /dev/null)" ]; then
    [ "$QUIET" ] || echo -e "\e[1m >> \e[35m$target\e[0m is a \e[1;31mgit\e[0m directory, skipping"
  else
    sh "$0" "$@"
  fi
  cd ..
}

if [ $(echo "$@" | grep '\-\-help') ]; then
  show_help_message
  exit 0
fi

while getopts 'hraqf' arg; do
  case "${arg}" in
    h)
      show_help_message
      exit 0
      ;;
    r)
      RECUR=recursive
      ;;
    a)
      # We have to ignore . and .. directories, otherwise
      # the recursive version would scan the whole computer!
      LS_OPTS=-A
      ;;
    q)
      QUIET=yes
      ;;
    f)
      FORCE=yes
      ;;
  esac
done

if [ "$FORCE" != yes ] ;then
  printf 'Are you sure you want to start chmodding things? [y/N] '
  read confirmation
fi

if ! [ "$confirmation" = y -o "$confirmation" = Y -o $(echo "$confirmation" | grep -i '^yes$' ) ]; then
  exit
fi

OLD_IFS="$IFS"
IFS='
'
for target in $(ls $LS_OPTS); do
  if [ -L "$target" ]; then
    [ "$QUIET" ] || echo -e "\e[1m >> \e[30;46m$target\e[0m is a \e[1;36msymbolic link\e[0m, we're not touching those"

  elif [ -f "$target" ]; then
    [ "$QUIET" ] || echo -e "\e[1;32mregular file\e[0m\t\e[1;36m$target\e[0m, removing execute permissions from it"
    chmod -x "$target"

  elif [ -d "$target" ]; then
    [ "$QUIET" ] || echo -e "\e[1;33mdirectory\e[0m\t\e[1;35m$target\e[0m, giving permission code 755 to it"
    chmod 755 "$target"

    [ "$RECUR" ] && reexecutes_recursively "$@" -f

  else
    [ "$QUIET" ] || echo -e "\e[1;31m$target\e[0m is neither a regular file nor a directory, doing nothing to it"
  fi
done
IFS="$OLD_IFS"
