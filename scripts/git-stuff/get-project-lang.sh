#!/bin/sh

project_root_dir=$(git rev-parse --show-toplevel 2> /dev/null)

if [ -z "$project_root_dir" ]; then
  project_root_dir=$(pwd)
fi

# if ls "$project_root_dir" | grep "^\(Rakefile\|config.ru\|Gemfile\(.lock\)\?\)$">/dev/null
# then
#   echo ruby
# elif ls "$project_root_dir" | grep "mix\.\(exs\|lock\)">/dev/null
# then
#   echo elixir
# elif ls "$project_root_dir" | grep "package\.json">/dev/null
# then
#   # I'm using `nodejs` because that is the asdf plugin name for javascript
#   echo nodejs
# fi

if [ -f "$project_root_dir/Gemfile" -o -f "$project_root_dir/config.ru" ]; then
  echo ruby
elif [ -f "$project_root_dir/mix.exs" ]; then
  echo elixir
elif [ -f "$project_root_dir/package.json" ]; then
  # I'm using `nodejs` because that is the asdf plugin name for javascript
  echo nodejs
fi
