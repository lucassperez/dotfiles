#!/bin/sh

cd $(dirname "$0")
DIR=$(pwd)

dir_not_in_list() {
  local dir=$1
  local dirs_list=$2
  echo "$dirs_list" | tr ',' "\n" | grep -vq "$dir"
}

recursively_symlink_scripts() {
  local current_dir=$1
  local destination_path=$2
  local dirs_list=$3

  for f in `ls`; do
    if [ -d $f ] && `dir_not_in_list "$f" "$dirs_list"`; then
      dirs_list="$f,$dirs_list"
      cd $f
      mkdir -p "$destination_path/$f"
      recursively_symlink_scripts `pwd` "$destination_path/$f" "$dirs_list"
      cd ..
    elif [ -x $f ] || echo "$f" | grep -q '\.sh$'; then
      ln -sfni "$current_dir/$f" "$destination_path/$f"
    fi
  done
}

printf "Symlinking config files for:\n"
printf "\tAlacritty\n"
printf "\tZsh (zshenv, zshrc, plugins/, completions/, aliases and functions)\n"
printf "\tScrpts folder\n"
printf "\tNvim\n"
printf "\tTmux\n"
printf "\tAwesomeWM (rc, my-theme and widgets/)\n"
printf "\tMime types, xinputrc and inputrc\n"
printf "\tDocker\n"
printf "\tTig\n"
printf "\tRofi\n"

mkdir -p "$HOME/.config/alacritty/"
ln -sfni "$DIR/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

ln -sfni "$DIR/shells/profile" "$HOME/.profile"
ln -sfni "$DIR/shells/aliases" "$HOME/.aliases"
ln -sfni "$DIR/shells/functions" "$HOME/.functions"
ln -sfni "$DIR/shells/zsh/zshenv" "$HOME/.zshenv"
mkdir -p "$HOME/.config/zsh/"
ln -sfni "$DIR/shells/zsh/zshrc" "$HOME/.config/zsh"
ln -sfni "$DIR/shells/zsh/plugins/" "$HOME/.config/zsh/plugins/"
ln -sfni "$DIR/shells/zsh/completions/" "$HOME/.config/zsh/completions/"

ln -sfni "$DIR/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/scripts/"
# Actually moving to scripts folder and then going back
cd "$DIR/scripts"
recursively_symlink_scripts "$DIR/scripts" "$HOME/scripts/"
cd $DIR

ln -sfni "$DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/awesome/"
ln -sfni "$DIR/awesome/rc.lua" "$HOME/.config/awesome/rc.lua"
ln -sfni "$DIR/awesome/my-theme.lua" "$HOME/.config/awesome/my-theme.lua"
ln -sfni "$DIR/awesome/widgets/" "$HOME/.config/awesome/widgets/"

ln -sfni "$DIR/mime.types" "$HOME/.mime.types"
ln -sfni "$DIR/xinput/xinputrc" "$HOME/.xinputrc"
ln -sfni "$DIR/inputrc" "$HOME/.config/inputrc"

mkdir -p "$HOME/.config/docker/"
ln -sfni "$DIR/docker/config.json" "$HOME/.config/docker/config.json"

mkdir -p "$HOME/.config/tig"
ln -sfni "$DIR/tig/config" "$HOME/.config/tig/config"

mkdir -p "$HOME/.config/rofi/"
ln -sfni "$DIR/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
ln -sfni "$DIR/rofi/meu-tema.rasi" "$HOME/.config/rofi/meu-tema.rasi"
