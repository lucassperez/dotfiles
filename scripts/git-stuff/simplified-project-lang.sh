#!/bin/sh

if [ -f ./Gemfile -o -f ./config.ru ]; then
  lang=ruby
elif [ -f ./mix.exs ]; then
  lang=elixir
elif [ -f ./package.json ]; then
  lang=nodejs
else
  exit
fi

asdf_output=$(asdf current "$lang" 2>/dev/null)
echo ${asdf_output%%/*}
