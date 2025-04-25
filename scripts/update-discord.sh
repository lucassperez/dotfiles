#!/bin/sh

while getopts 'h:l:m:' arg; do
  case "$arg" in
    h)
      home="$OPTARG"
      ;;
    l)
      log="$OPTARG"
      ;;
    m)
      message="$OPTARG"
      ;;
  esac
done

if [ -z $home ]; then
  home="$HOME"
fi

if [ -n "$log" ]; then
  echo "=== $(date) ===" >> $log
  echo "Parâmetros (@): $@" >> $log
  if [ -n "$message" ]; then
    echo "$message" >> $log
  fi
fi

which jq >/dev/null || exit
which wget >/dev/null || exit

mkdir -pv "$home/sources/discord-tar-balls"
mkdir -pv "$home/.local/bin"

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

update_version_file() {
  local version_file=$1
  local version=$2

  if [ -f "$version_file" ]; then
    printf -- "=== Updating the discord version file: $version_file ===\n"
  else
    printf -- "=== Creating the discord version file: $version_file ===\n"
  fi
  echo "{\"version\": \"$version\", \"last_check\": \"$(date '+%Y-%m-%d %H:%M:%S %z')\"}" | jq > $version_file
}

### Baixa o discord.
####################

printf -- '\n=== Downloading discord ===\n\n'

tmp_dir=`mktemp -d "/tmp/discord_$(date '+%N')_XXXXX"`
tar_file="$tmp_dir/discord.tar.gz"

wget 'https://discord.com/api/download?platform=linux&format=tar.gz' -O "$tar_file"
tar -x -f "$tar_file" -C "$tmp_dir"

### Verifica a versão atual com a baixada.
##########################################

discord_ver=`jq '.version' "$tmp_dir/Discord/resources/build_info.json" | tr -d '"'`

version_file="$home/sources/discord-tar-balls/my_current_discord_version.json"

if [ -f $version_file ]; then
  current_version=`jq '.version' $version_file | tr -d '"'`
else
  current_version=''
fi

if [ "$current_version" = "$discord_ver" ]; then
  printf -- "=== Discord is already on latest version: $current_version ===\n"
  printf -- "=== Removing temporary directory: $tmp_dir ===\n"
  rm -r $tmp_dir

  update_version_file $version_file $current_version

  printf -- "=== Exiting ===\n"
  exit
fi

### Verifica se já existe um diretório com o nome novo.
### Com o passo anterior de verificar a versão
### atual, isso não deveria mais ser necessário,
### mas eu mantive mesmo assim.
#######################################################

discord_dir="$home/sources/discord-tar-balls/discord-$discord_ver"

if [ -d "$discord_dir" ]; then
  new_old_dir_name=`add_old_sufix $discord_dir`
  printf -- "=== Directory $discord_dir already exists, renaming it to $new_old_dir_name ===\n"
  mv $discord_dir $new_old_dir_name
fi

### Move o diretório descomprimido, Discord.
### Tira lá do diretório temporário (/tmp/discord_...)
### e coloca na home do usuário (discord_dir, ~/sources/discord-tar-balls/...).
###############################################################################

mkdir $discord_dir
mv "$tmp_dir/Discord" "$discord_dir"

### Cria o symlink, deletando caso ele já exista.
#################################################

if [ -L "$home/.local/bin/discord" ]; then
  printf -- "=== Symlink in $home/.local/bin/discord already exists, DELETING it! ===\n"
  rm "$home/.local/bin/discord"
elif [ -e "$home/.local/bin/discord" ]; then
  new_old_discord_path=`add_old_sufix "$home/.local/bin/discord"`
  printf -- "=== File in $home/.local/bin/discord already exists, renaming it to $new_old_discord_path ===\n"
  mv "$home/.local/bin/discord" $new_old_discord_path
fi

printf -- "=== Creating symlink to $home/.local/bin/discord ===\n"
ln -s "$discord_dir/Discord/Discord" "$home/.local/bin/discord"

### Move o arquivo tar que foi baixado.
### Tira do diretório temporário (/tmp/discord...)
### e põe na home do usuário também (discord_dir, ~/sources/discord-tar-balls/...).
###################################################################################

new_tar_path="$home/sources/discord-tar-balls/discord-$discord_ver.tar.gz"
if [ -e "$new_tar_path" ]; then
  new_old_tar_name=`add_old_sufix_tar $new_tar_path tar`
  printf -- "=== File $new_tar_path already exists, renaming it to $new_old_tar_name ===\n"
  mv $new_tar_path $new_old_tar_name
fi
mv $tar_file $new_tar_path

### Remove o diretório temporário.
### Ele deve estar vazio agora que já foram movidos o
### diretório descomprimido (Discord) e o tar.
### Portanto, o rmdir deve funcionar.
#####################################################

printf -- "=== Removing temporary directory: $tmp_dir\n"
rmdir "$tmp_dir"

### Cria ou atualiza o arquivo de versão.
#########################################

update_version_file $version_file $discord_ver
printf -- "=== Exiting ===\n"
exit
