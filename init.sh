#!/bin/sh

cd $(dirname "$0")
DIR=$(pwd)

echo "Creating symlink to: \e[1;36m$HOME/.config/alacritty\e[0m"
ln -sfni "$DIR/alacritty/" "$HOME/.config/alacritty"

echo "Creating symlink to: \e[1;36m$HOME/.bashrc\e[0m"
ln -sfni "$DIR/bash/bashrc" "$HOME/.bashrc"

echo "Creating symlink to: \e[1;36m$HOME/.bash_profile\e[0m"
ln -sfni "$DIR/bash/bash_profile" "$HOME/.bash_profile"

echo "Creating symlink to: \e[1;36m$HOME/.config/kitty\e[0m"
ln -sfni "$DIR/kitty/" "$HOME/.config/kitty"

echo "Creating symlink to: \e[1;36m$HOME/.config/nvim\e[0m"
ln -sfni "$DIR/nvim/" "$HOME/.config/nvim"

echo "Creating symlink to: \e[1;36m$HOME/scripts\e[0m"
ln -sfni "$DIR/scripts/" "$HOME/scripts"

echo "Creating symlink to: \e[1;36m$HOME/.tmux.conf\e[0m"
ln -sfni "$DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "Creating symlink to: \e[1;36m$HOME/.xinputrc\e[0m"
ln -sfni "$DIR/xinput/xinputrc" "$HOME/.xinputrc"

echo "Creating symlink to: \e[1;36m$HOME/.mime.types\e[0m"
ln -sfni "$DIR/mime.types" "$HOME/.mime.types"
