# Dotfiles

Configuration files for my most used programs:
- Neovim
- Tmux
- Alacritty
- Zsh
- AwesomeWM

It also has other configurations I use on my compures and convenience scripts.

It also features an _ARCHIVE_ directorie with some other program configs,
usually because I have tinkered with them for fun or because I have used them in
the past.

Feel free to copy, use, get inspired by and comment on my dotfiles! (:

## Installation

To install, simply clone this directory and run `./init.sh` from the root directory.

This script will create symlinks from the cloned directory to the usual places
of these configuration files (it makes some assumptions).

If assumes you have or config files in "$HOME/.config". I'm not using XDG_CONFIG_HOME
because when I have a fresh install, I might want to run this script before setting
this variable, so I just wanted to simplify my life. Sorry about that!

For example, it will symlink the cloned `nvim` directory to `$HOME/.config/nvim`.

If the destination file/directory already exists, the `ln` command will prompt for confirmation.

**Depencies _won't_ be installed!**

## Emojis in Alacritty

https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
https://github.com/alacritty/alacritty/issues/153

Copy the `fontconfig/fonts.conf` to `"$XDG_CONFIG_HOME/fontconfig/fonts.conf"` and
then run `fc-cache -f` and `sudo fc-cache -f`.
