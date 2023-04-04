#!/bin/sh

# If running this script first time after cloning, there is a chance
# XDG_CONFIG_HOME is still not set, and if it is not the usual $HOME/.config,
# things might get symlinked to werid spots!
# Thus, the first argument passed to this script is used as the CONFIG_DIR
CONFIG_DIR="${1:-${XDG_CONFIG_HOME:-$HOME/.config}}"
mkdir -pv $CONFIG_DIR

dir_not_in_list() {
  local dir=$1
  local dirs_list=$2
  echo "$dirs_list" | tr ',' "\n" | grep -vq "$dir"
}

do_symlink_scripts_recur() {
  local current_dir=$1
  local destination_path=$2
  local visited_dirs_list=$3

  for f in `ls`; do
    if [ -d $f ] && `dir_not_in_list "$f" "$visited_dirs_list"`; then
      visited_dirs_list="$f,$visited_dirs_list"
      cd $f
      mkdir -p "$destination_path/$f"
      do_symlink_scripts_recur `pwd` "$destination_path/$f" "$visited_dirs_list"
      cd ..
    # elif [ -x $f ] || echo "$f" | grep -q '\.sh$'; then
    # Before I was only symlinking executable files or files that ended
    # in ".sh", but since the "emojis" dmenu script actually uses some
    # other files, I'm just symlinking every normal file.
    elif [ -f $f ]; then
      ln -sfni "$current_dir/$f" "$destination_path/$f"
    fi
  done
}

recursively_symlink_scripts() {
  cd "$DIR/scripts"
  do_symlink_scripts_recur "$DIR/scripts" "$HOME/scripts"
  cd "$DIR"
}

symlink_all_files_in_dir() {
  cd $1

  local current_dir=$1
  local destination_path=$2

  for f in `ls`; do
    if ! [ -d $f ]; then
      ln -sfni "$current_dir/$f" "$destination_path/$f"
    fi
  done

  cd $DIR
}

# Get this script's dir name.
# With this, the init script can be
# invoked from anywhere.
cd $(dirname "$0")
DIR=$(pwd)

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

mkdir -p "$CONFIG_DIR/alacritty/"
ln -sfni "$DIR/alacritty/alacritty.yml" "$CONFIG_DIR/alacritty/alacritty.yml"

ln -sfni "$DIR/shells/profile" "$HOME/.profile"
ln -sfni "$DIR/shells/aliases" "$HOME/.aliases"
ln -sfni "$DIR/shells/functions" "$HOME/.functions"
ln -sfni "$DIR/shells/zsh/zshenv" "$HOME/.zshenv"
mkdir -p "$CONFIG_DIR/zsh/"
ln -sfni "$DIR/shells/zsh/zshrc" "$CONFIG_DIR/zsh/.zshrc"
mkdir -p "$CONFIG_DIR/zsh/plugins"
mkdir -p "$CONFIG_DIR/zsh/completions"
symlink_all_files_in_dir "$DIR/shells/zsh/plugins" "$CONFIG_DIR/zsh/plugins"
symlink_all_files_in_dir "$DIR/shells/zsh/completions" "$CONFIG_DIR/zsh/completions"

ln -sfni "$DIR/nvim" "$CONFIG_DIR/nvim"

mkdir -p "$HOME/scripts/"
recursively_symlink_scripts

mkdir -p "$CONFIG_DIR/tmux"
ln -sfni "$DIR/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

mkdir -p "$CONFIG_DIR/awesome/"
ln -sfni "$DIR/awesome/rc.lua" "$CONFIG_DIR/awesome/rc.lua"
ln -sfni "$DIR/awesome/my-theme.lua" "$CONFIG_DIR/awesome/my-theme.lua"
ln -sfni "$DIR/awesome/widgets" "$CONFIG_DIR/awesome/widgets"
mkdir -p "$CONFIG_DIR/awesome/limited-tile"
ln -sfni "$DIR/awesome/limited-tile/init.lua" "$CONFIG_DIR/awesome/limited-tile/init.lua"
ln -sfni "$DIR/awesome/limited-tile/limitedtile.png" "$CONFIG_DIR/awesome/limited-tile/limitedtile.png"
ln -sfni "$DIR/awesome/limited-tile/limitedtilew.png" "$CONFIG_DIR/awesome/limited-tile/limitedtilew.png"

ln -sfni "$DIR/mime.types" "$HOME/.mime.types"
ln -sfni "$DIR/xinput/xinputrc" "$HOME/.xinputrc"
ln -sfni "$DIR/inputrc" "$CONFIG_DIR/inputrc"

mkdir -p "$CONFIG_DIR/docker/"
ln -sfni "$DIR/docker/config.json" "$CONFIG_DIR/docker/config.json"

mkdir -p "$CONFIG_DIR/tig"
ln -sfni "$DIR/tig/config" "$CONFIG_DIR/tig/config"

mkdir -p "$CONFIG_DIR/rofi/"
ln -sfni "$DIR/rofi/config.rasi" "$CONFIG_DIR/rofi/config.rasi"
ln -sfni "$DIR/rofi/meu-tema.rasi" "$CONFIG_DIR/rofi/meu-tema.rasi"

if ! [ -e "$DIR/.git/hooks/commit-msg" ]; then
  printf "Copying commit-msg git hook\n"
  cp "$DIR/git-hooks/commit-msg" "$DIR/.git/hooks/commit-msg"
  chmod +x "$DIR/.git/hooks/commit-msg"
fi
