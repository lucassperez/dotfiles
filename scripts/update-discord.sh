#!/bin/sh

# Esse não funciona porque o comando Discord -v bloqueia!
# Ele abre o Discord e o script fica travado.
# discord_ver=`./Discord/Discord -v | sed -n 's/Discord \([0\.]*\)/\1/p'`
# Pra pegar a versão, to usando jq e o build_info.json.

which jq >/dev/null || exit
which wget >/dev/null || exit

mkdir -pv "$HOME/sources/discord-tar-balls"
mkdir -pv "$HOME/.local/bin"

add_old_sufix() {
  if [ -e $1 ]; then
    add_old_sufix "$1-OLD"
  else
    printf $1
  fi
}

add_old_sufix_tar() {
  if [ -e "$1" ]; then
    name_without_tar=`echo $1 | sed 's/\.tar\.gz//'`
    add_old_sufix_tar "$name_without_tar-OLD.tar.gz"
  else
    printf $1
  fi
}

printf -- '\n=== Downloading discord ===\n\n'

wget 'https://discord.com/api/download?platform=linux&format=tar.gz'
tar -x -f 'download?platform=linux&format=tar.gz'

discord_ver=`jq '.version' ./Discord/resources/build_info.json | tr -d '"'`
discord_dir="$HOME/sources/discord-tar-balls/discord-$discord_ver"

if [ -d "$discord_dir" ]; then
  new_old_dir_name=`add_old_sufix $discord_dir`
  printf -- "=== Directory $discord_dir already exists, renaming it to $new_old_dir_name ===\n"
  mv $discord_dir $new_old_dir_name
fi

mkdir $discord_dir
mv Discord $discord_dir

if [ -L "$HOME/.local/bin/discord" ]; then
  printf -- "\n=== Symlink in $HOME/.local/bin/discord already exists, DELETING it! ===\n\n"
  rm "$HOME/.local/bin/discord"
elif [ -e "$HOME/.local/bin/discord" ]; then
  new_old_discord_path=`add_old_sufix "$HOME/.local/bin/discord"`
  printf -- "=== File in $HOME/.local/bin/discord already exists, renaming it to $new_old_discord_path ===\n"
  mv "$HOME/.local/bin/discord" $new_old_discord_path
fi

printf -- "=== Creating symlink to $HOME/.local/bin/discord ===\n"
ln -s "$discord_dir/Discord/Discord" "$HOME/.local/bin/discord"

tar_path="$HOME/sources/discord-tar-balls/discord-$discord_ver.tar.gz"
if [ -e "$tar_path" ]; then
  new_old_tar_name=`add_old_sufix_tar $tar_path tar`
  printf -- "=== File $tar_path already exists, renaming it to $new_old_tar_name ===\n"
  mv $tar_path $new_old_tar_name
fi
mv 'download?platform=linux&format=tar.gz' $tar_path
