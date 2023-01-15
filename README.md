# Dotfiles

Configuration files for my most used programs:
- Neovim
- Tmux
- Alacritty
- Zsh
- AwesomeWM

It also has other configurations I use on my computers and convenience scripts.

It also features an _ARCHIVE_ directory with some other program configs,
usually because I have tinkered with them for fun or because I have used them in
the past.

Feel free to copy, use, get inspired by and comment on my dotfiles! (:

## Installation

To install, simply clone this directory and run the `/init.sh` script. It can be
run from anywhere.

This script will create symlinks from the cloned directory to the usual places
of these configuration files (it makes some assumptions).

If the destination file/directory already exists, the `ln` command will prompt for confirmation.

**Depencies _won't_ be installed!**

### Important

This script will try to symlink the configurations to `$XDG_CONFIG_HOME` or
simply to `$HOME/.config` it the first is not set. When I have a fresh install,
I might want to run this script before setting this variable, so it uses `$HOME/.config`.

**This is a problem if your `$XDG_CONFIG_HOME` it not __going to be__ `$HOME/.config`!!**

If that is the case, please call this script providing the correct path of your
future `$XDG_CONFIG_HOME` as the first argument.

```sh
./init.sh /path/to/my/config/dir
```

**Attention**

Some programs and scripts inside the ARCHIVE directory might assume that your
config dir is in fact `$HOME/.config`, even if your `$XDG_CONFIG_HOME` is
something else.

## Emojis in Alacritty

https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
<br/>
https://github.com/alacritty/alacritty/issues/153

Copy the `fontconfig/fonts.conf` to `"$XDG_CONFIG_HOME/fontconfig/fonts.conf"` and
then run `fc-cache -f` and `sudo fc-cache -f`.
