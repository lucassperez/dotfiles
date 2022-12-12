#!/bin/sh

cd $(dirname "$0")
DIR=$(pwd)

recursively_symlink_scripts() {
  local current_dir=$1
  local destination_path=$2
  for f in `ls`; do
    if [ -d $f ]; then
      cd $f
      printf "Creating \e[1m$destination_path/$f\e[0m if it does not already exists\n"
      mkdir -p "$destination_path/$f"
      recursively_symlink_scripts `pwd` "$destination_path/$f"
      cd ..
    elif [ -x $f ] || echo "$f" | grep -q '\.sh$'; then
      printf "Creating symlink to: \e[1;36m$destination_path/$f\e[0m\n"
      ln -sfni "$current_dir/$f" "$destination_path/$f"
    fi
  done
}

echo Bash or Zsh?
printf "z = Zsh, any other = Bash: "
read INSTALL_SHELL

echo i3, Awesome or neither?
printf "i = i3, a = Awesome, any other = neither: "
read INSTALL_WM

printf "Creating symlink to: \e[1;36m$HOME/.config/alacritty\e[0m\n"
ln -sfni "$DIR/alacritty/" "$HOME/.config/alacritty"

printf "Creating symlink to: \e[1;36m$HOME/.profile\e[0m\n"
ln -sfni "$DIR/shells/profile" "$HOME/.profile"

if [ "$INSTALL_SHELL" = z ]; then
  printf "Creating symlink to: \e[1;36m$HOME/.zshenv\e[0m\n"
  ln -sfni "$DIR/shells/zsh/zshenv" "$HOME/.zshenv"

  [ -d "$HOME/.config/zsh" ] || mkdir "$HOME/.config/zsh" -pv

  printf "Creating symlink to: \e[1;36m$HOME/.config/zsh/.zshrc\e[0m\n"
  ln -sfni "$DIR/shells/zsh/zshrc" "$HOME/.config/zsh/.zshrc"

  printf "Creating symlink to: \e[1;36m$HOME/.config/zsh/plugins\e[0m\n"
  ln -sfni "$DIR/shells/zsh/plugins" "$HOME/.config/zsh/plugins"

  printf "Creating symlink to: \e[1;36m$HOME/.config/zsh/completions\e[0m\n"
  ln -sfni "$DIR/shells/zsh/completions" "$HOME/.config/zsh/completions"
else
  printf "Creating symlink to: \e[1;36m$HOME/.bashrc\e[0m\n"
  ln -sfni "$DIR/shells/bash/bashrc" "$HOME/.bashrc"

  printf "Creating symlink to: \e[1;36m$HOME/.bash_profile\e[0m\n"
  ln -sfni "$DIR/shells/bash/bash_profile" "$HOME/.bash_profile"
fi

printf "Creating symlink to: \e[1;36m$HOME/.aliases\e[0m\n"
ln -sfni "$DIR/shells/aliases" "$HOME/.aliases"

printf "Creating symlink to: \e[1;36m$HOME/.functions\e[0m\n"
ln -sfni "$DIR/shells/functions" "$HOME/.functions"

printf "Creating symlink to: \e[1;36m$HOME/.config/kitty\e[0m\n"
ln -sfni "$DIR/kitty/" "$HOME/.config/kitty"

printf "Creating symlink to: \e[1;36m$HOME/.config/nvim\e[0m\n"
ln -sfni "$DIR/nvim/" "$HOME/.config/nvim"

[ -d "$HOME/scripts" ] || mkdir "$HOME/scripts" -pv

cd "$DIR/scripts"
recursively_symlink_scripts "$DIR" "$HOME/scripts"
cd $DIR

printf "Creating symlink to: \e[1;36m$HOME/.tmux.conf\e[0m\n"
ln -sfni "$DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

if [ "$INSTALL_WM" = i ]; then
  [ -d "$HOME/.config/i3" ] || mkdir -pv "$HOME/.config/i3"

  printf "Creating symlink to: \e[1;36m$HOME/.config/i3/config\e[0m\n"
  ln -sfni "$DIR/i3/config" "$HOME/.config/i3/config"

  printf "Creating symlink to: \e[1;36m$HOME/.config/i3/i3blocks.conf\e[0m\n"
  ln -sfni "$DIR/i3/i3blocks.conf" "$HOME/.config/i3/i3blocks.conf"

  printf "Creating symlink to: \e[1;36m$HOME/.config/i3/blocklets-scripts\e[0m\n"
  ln -sfni "$DIR/i3/blocklets-scripts" "$HOME/.config/i3/blocklets-scripts"

  [ -d "$HOME/.config/polybar" ] || mkdir -pv "$HOME/.config/polybar"

  printf "Creating symlink to: \e[1;36m$HOME/.config/polybar/launch.sh\e[0m\n"
  ln -sfni "$DIR/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"

  printf "Creating symlink to: \e[1;36m$HOME/.config/polybar/config\e[0m\n"
  ln -sfni "$DIR/polybar/config" "$HOME/.config/polybar/config"

  printf "Creating symlink to: \e[1;36m$HOME/.config/polybar/config/scripts\e[0m\n"
  ln -sfni "$DIR/polybar/config/scripts" "$HOME/.config/polybar/config/scripts"

elif [ "$INSTALL_WM" = a ]; then
  [ -d "$HOME/.config/awesome" ] || mkdir -pv "$HOME/.config/awesome"

  printf "Creating symlink to: \e[1;36m$HOME/.config/awesome/rc.lua\e[0m\n"
  ln -sfni "$DIR/awesome/rc.lua" "$HOME/.config/awesome/rc.lua"

  printf "Creating symlink to: \e[1;36m$HOME/.config/awesome/my-theme.lua\e[0m\n"
  ln -sfni "$DIR/awesome/my-theme.lua" "$HOME/.config/awesome/my-theme.lua"

  printf "Creating symlink to: \e[1;36m$HOME/.config/awesome/widgets\e[0m\n"
  ln -sfni "$DIR/awesome/widgets" "$HOME/.config/awesome/widgets"
fi

printf "Creating symlink to: \e[1;36m$HOME/.xinputrc\e[0m\n"
ln -sfni "$DIR/xinput/xinputrc" "$HOME/.xinputrc"

printf "Creating symlink to: \e[1;36m$HOME/.mime.types\e[0m\n"
ln -sfni "$DIR/mime.types" "$HOME/.mime.types"

mkdir -pv "$HOME/.config/docker"
printf "Creating symlink to: \e[1;36m$HOME/.config/docker/config.json\e[0m\n"
ln -sfni "$DIR/docker/config.json" "$HOME/.config/docker/config.json"

mkdir -pv "$HOME/.config/tig"
printf "Creating symlink to: \e[1;36m$HOME/.config/tig/config\e[0m\n"
ln -sfni "$DIR/tig/config" "$HOME/.config/tig/config"

printf "Creating symlink to: \e[1;36m$HOME/.config/inputrc\e[0m\n"
ln -sfni "$DIR/inputrc" "$HOME/.config/xinputrc"
