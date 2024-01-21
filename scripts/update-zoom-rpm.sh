#!/bin/sh

add_old_sufix() {
  if [ -e "$HOME/Downloads/zoom/$1.rpm" ]; then
    add_old_sufix "$1-OLD"
  else
    printf $1
  fi
}

check_if_current_zoom_is_latest() {
  local current_zoom_version=`rpm -q zoom`

  if [ "$?" != 0 ]; then
    # Zoom não está instalado
    return 1
  fi


  local new_zoom_candidate_version=`rpm -q $1`
  if [ "$new_zoom_candidate_version" != "$current_zoom_version" ]; then
    return 1
  fi

  return 0
}

tmp_zoom_rpm_path="$HOME/Downloads/zoom/zoom-tmp.rpm"

mkdir -p ~/Downloads/zoom/
wget -O "$tmp_zoom_rpm_path" -- https://zoom.us/client/latest/zoom_x86_64.rpm

# check if current zoom is the same version
if check_if_current_zoom_is_latest "$tmp_zoom_rpm_path"; then
  echo 'Zoom já está instalado e na versão mais nova'
  echo "Deletando $tmp_zoom_rpm_path"
  rm "$tmp_zoom_rpm_path"
  exit
fi

# version=`rpm -qp ~/Downloads/zoom/zoom-tmp.rpm 2>/dev/null`
version=`rpm -qp ~/Downloads/zoom/zoom-tmp.rpm`

filename=`add_old_sufix $version`.rpm

if echo $filename | grep -q '\-OLD.rpm'; then
  mv "$HOME/Downloads/zoom/$version.rpm" "$HOME/Downloads/zoom/$filename"
fi

sudo dnf install -y ~/Downloads/zoom/zoom-tmp.rpm
# sudo rpm -i ~/Downloads/zoom/zoom-tmp.rpm
mv ~/Downloads/zoom/zoom-tmp.rpm "$HOME/Downloads/zoom/$version.rpm"
