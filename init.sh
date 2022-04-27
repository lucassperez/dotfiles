#!/bin/sh

cd $(dirname "$0")
DIR=$(pwd)

echo Bash or Zsh?
printf "z = Zsh, any other = Bash: "
read INSTALL_SHELL

echo i3, Awesome or neither?
printf "i = i3, a = Awesome, any other = neither: "
read INSTALL_WM

echo "Creating symlink to: \e[1;36m$HOME/.config/alacritty\e[0m"
ln -sfni "$DIR/alacritty/" "$HOME/.config/alacritty"

if [ "$INSTALL_SHELL" = z ]; then
  echo "Creating symlink to: \e[1;36m$HOME/.zshenv\e[0m"
  ln -sfni "$DIR/shells/zsh/zshenv" "$HOME/.zshenv"

  [ -d "$HOME/.config/zsh" ] || mkdir "$HOME/.config/zsh" -pv

  echo "Creating symlink to: \e[1;36m$HOME/.config/zsh/.zshrc\e[0m"
  ln -sfni "$DIR/shells/zsh/zshrc" "$HOME/.config/zsh/.zshrc"

  echo "Creating symlink to: \e[1;36m$HOME/.config/zsh/plugins\e[0m"
  ln -sfni "$DIR/shells/zsh/plugins" "$HOME/.config/zsh/plugins"

  echo "Creating symlink to: \e[1;36m$HOME/.config/zsh/completions\e[0m"
  ln -sfni "$DIR/shells/zsh/completions" "$HOME/.config/zsh/completions"
else
  echo "Creating symlink to: \e[1;36m$HOME/.bashrc\e[0m"
  ln -sfni "$DIR/shells/bash/bashrc" "$HOME/.bashrc"

  echo "Creating symlink to: \e[1;36m$HOME/.bash_profile\e[0m"
  ln -sfni "$DIR/shells/bash/bash_profile" "$HOME/.bash_profile"
fi

echo "Creating symlink to: \e[1;36m$HOME/.aliases\e[0m"
ln -sfni "$DIR/shells/aliases" "$HOME/.aliases"

echo "Creating symlink to: \e[1;36m$HOME/.config/kitty\e[0m"
ln -sfni "$DIR/kitty/" "$HOME/.config/kitty"

echo "Creating symlink to: \e[1;36m$HOME/.config/nvim\e[0m"
ln -sfni "$DIR/nvim/" "$HOME/.config/nvim"

[ -d "$HOME/scripts" ] || mkdir "$HOME/scripts" -pv

echo Creating symlinks to the following scripts to "\e[1;36m$HOME/scripts\e[0m" directory:
echo Files:"\t \e[1mparse-tmux-ls.sh\e[0m, \e[1mlambda-fetch.sh\e[0m, \e[1mchmod-back-to-normal.sh\e[0m, \e[1msimplexev.sh\e[0m, \e[1msetwallpaper.sh, enable-touchpad-tap.sh\e[0m"
echo Folders:" \e[1mgit-stuff/\e[0m, \e[1mtmux-chtsh/\e[0m, \e[1memoji/\e[0m"
ln -sfni "$DIR/scripts/parse-tmux-ls.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/lambda-fetch.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/chmod-back-to-normal.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/simplexev.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/setwallpaper.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/enable-touchpad-tap.sh" "$HOME/scripts"
ln -sfni "$DIR/scripts/git-stuff" "$HOME/scripts"
ln -sfni "$DIR/scripts/tmux-chtsh" "$HOME/scripts"
ln -sfni "$DIR/scripts/emoji" "$HOME/scripts"

echo "Creating symlink to: \e[1;36m$HOME/.tmux.conf\e[0m"
ln -sfni "$DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

if [ "$INSTALL_WM" = i ]; then
  [ -d "$HOME/.config/i3" ] || mkdir "$HOME/.config/i3" -pv

  echo "Creating symlink to: \e[1;36m$HOME/.config/i3/config\e[0m"
  ln -sfni "$DIR/i3/config" "$HOME/.config/i3/config"

  echo "Creating symlink to: \e[1;36m$HOME/.config/i3/i3blocks.conf\e[0m"
  ln -sfni "$DIR/i3/i3blocks.conf" "$HOME/.config/i3/i3blocks.conf"

  echo "Creating symlink to: \e[1;36m$HOME/.config/i3/blocklets-scripts\e[0m"
  ln -sfni "$DIR/i3/blocklets-scripts" "$HOME/.config/i3/blocklets-scripts"

  [ -d "$HOME/.config/polybar" ] || mkdir "$HOME/.config/polybar"

  echo "Creating symlink to: \e[1;36m$HOME/.config/polybar/launch.sh\e[0m"
  ln -sfni "$DIR/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"

  echo "Creating symlink to: \e[1;36m$HOME/.config/polybar/config\e[0m"
  ln -sfni "$DIR/polybar/config" "$HOME/.config/polybar/config"

  echo "Creating symlink to: \e[1;36m$HOME/.config/polybar/config/scripts\e[0m"
  ln -sfni "$DIR/polybar/config/scripts" "$HOME/.config/polybar/config/scripts"

elif [ "$INSTALL_WM" = a ]; then
  [ -d "$HOME/.config/awesome" ] || mkdir "$HOME/.config/awesome" -pv

  echo "Creating symlink to: \e[1;36m$HOME/.config/awesome/rc.lua\e[0m"
  ln -sfni "$DIR/awesome/rc.lua" "$HOME/.config/awesome/rc.lua"

  echo "Creating symlink to: \e[1;36m$HOME/.config/awesome/my-theme.lua\e[0m"
  ln -sfni "$DIR/awesome/my-theme.lua" "$HOME/.config/awesome/my-theme.lua"

  echo "Creating symlink to: \e[1;36m$HOME/.config/awesome/widgets\e[0m"
  ln -sfni "$DIR/awesome/widgets" "$HOME/.config/awesome/widgets"
fi

echo "Creating symlink to: \e[1;36m$HOME/.xinputrc\e[0m"
ln -sfni "$DIR/xinput/xinputrc" "$HOME/.xinputrc"

echo "Creating symlink to: \e[1;36m$HOME/.mime.types\e[0m"
ln -sfni "$DIR/mime.types" "$HOME/.mime.types"
