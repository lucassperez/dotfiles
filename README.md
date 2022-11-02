# Dotfiles

Configuration files for my most used programs:
- Neovim
- Tmux
- Alacritty
- Zsh
- AwesomeWM

It also features some other program configs, usually because I have tinkered
with them for fun or because I have used them in the past.

Feel free to copy, use, get inspired by and comment on my dotfiles! (:

## Installation

To install, simply clone this directory and run `./init.sh` from the root directory.

This script will create symlinks from the cloned directory to the usual places
of these configuration files (it makes some assumptions).

It will also prompt you for either Bash or Zsh.

For example, it will symlink the cloned `nvim` directory to `$HOME/.config/nvim`.

If the destination file/directory already exists, the `ln` command will prompt for confirmation.

Depencies won't be installed, though.
