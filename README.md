# Dotfiles

Configuration files for my mostly used programs:
- Neovim
- Tmux
- Alacritty
- Bash (sample bashrc)

It also features some old Kitty configs, though I stopped using it.

Feel free to copy, use, get inspired by and comment on my dotfiles! (:

## Installation

To install, simply clone this directory and run `sh init.sh`.

This script will create symlinks from the cloned directory to the usual places
of these configuration files.

For example, it will symlink the cloned `nvim` directory to `$HOME/.config/nvim`.

If the destination file/directory already exists, the `ln` command will prompt for confirmation.

Depencies won't be installed, though.
