#!/bin/sh

if [ -f ./Gemfile -o -f ./config.ru ]; then
  lang=ruby
elif [ -f ./mix.exs ]; then
  lang=elixir
elif [ -f ./package.json ]; then
  lang=nodejs
else
  if [ ! "$(git rev-parse --git-dir 2> /dev/null)" ]; then
    exit 1
  fi
  project_root_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -f "$project_root_dir/Gemfile" -o -f "$project_root_dir/config.ru" ]; then
    lang=ruby
  elif [ -f "$project_root_dir/mix.exs" ]; then
    lang=elixir
  elif [ -f "$project_root_dir/package.json" ]; then
    lang=nodejs
  else
    exit
  fi
fi

asdf_output=$(asdf current "$lang" 2>/dev/null)
echo ${asdf_output%%/*}
