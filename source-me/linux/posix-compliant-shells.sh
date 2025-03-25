#!/usr/bin/env bash

source ~/Documents/scripts/source-me/posix-compliant-shells.sh

if [ -z "$NOT_HOST_ENV" ]; then
  # used in sniff & httpdump
  export _ngrep_interface=wlp4s0

  xset -b || true  # disable bell
  setxkbmap -option "ctrl:nocaps" || true  # change caps-lock to ctrl
fi


GIT_AUTHOR_NAME="$(read_toml_setting ~/Documents/config/git.conf name)"
GIT_AUTHOR_EMAIL="$(read_toml_setting ~/Documents/config/git.conf email)"
export GIT GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"


# make sure SUDO keeps SYSTEMD environment variables, otherwise this will
# not change anything
#
# $ grep SYSTEMD_ /etc/sudoers
# Defaults env_keep += "SYSTEMD_COLORS SYSTEMD_PAGER SYSTEMD_LESS"
#
export SYSTEMD_COLORS=0


_add_to_PATH /usr/share/git/git-jump

_add_to_PATH "$HOME/Documents/scripts/bin/linux"  || true



# IP addresses
# shellcheck disable=SC2142
alias public-ip="drill myip.opendns.com @resolver1.opendns.com | awk '/IN\s+A\s+\w+/ { print \$5 }'"
# shellcheck disable=SC2142
alias local-ip="ip addr show dev wlan0 | awk '/inet/ { sub(/inet6? (addr:)? ?/, \"\"); print \$1 }'"
# shellcheck disable=SC2142
alias ips="ip addr |  awk '/inet/ { sub(/inet6? (addr:)? ?/, \"\"); print \$1 }'"


pacman-last-actions () {
  tail /var/log/pacman.log -n 20000 | grep -E 'installed|pacman(.*)\-U|upgraded|removed'
}


remove-gnome-history () {
  file_dir=~/.local/share
  set -x
  find "$file_dir" -maxdepth 1 -type f -name 'recently-used.xbel*' -delete
  set +x
}


chromium () {
  (command chromium --force-device-scale-factor=1.5 "$@" 1>/dev/null 2>/dev/null &)
}

_snap () {
  local d
  local dir
  local size

  dir="$1"
  d="$2"

  if [ $# -lt 3 ]; then
    size='4GB'
  else
    size="$3"
  fi
  sudo lvcreate -L "$size" -s -n "s_$dir-$d" "$vol_group_mapper-$dir"
}



open_file_if_not_open () {
  local filename="$1"
  if ! ps -ef | grep -v grep | grep -q "$(basename "$filename")"; then
    xdg-open "$filename"  # xdg-open should be a function already
  fi
}

xdg-open () {
  (command xdg-open "$@" >/dev/null 2>&1 &)
}



_xrandr_fst_mon () {
  #
  # possible values:
  # - eDP1
  # - eDP-1
  #
  xrandr -q | grep -v disconnected | grep connected | awk '{ print $1 }' | head -n1
}
_xrandr_snd_mon () {
  #
  # possible values:
  # - HDMI2
  # - DP2
  # - DP1
  # - DP-4
  #
  xrandr -q | grep -v disconnected | grep connected | awk '{ print $1 }' | tail -n1
}
xrandr-right-of () {
  xrandr --output "$(_xrandr_snd_mon)" --right-of "$(_xrandr_fst_mon)" --auto
}
xrandr-left-of () {
  xrandr --output "$(_xrandr_snd_mon)" --left-of "$(_xrandr_fst_mon)" --auto
}
xrandr-above () {
  xrandr --output "$(_xrandr_snd_mon)" --above "$(_xrandr_fst_mon)" --auto
}
xrandr-same-as () {
  xrandr --output "$(_xrandr_snd_mon)" --same-as "$(_xrandr_fst_mon)" --auto
}
xrandr-off () {
  if [ "$(_xrandr_fst_mon)" = "$(_xrandr_snd_mon)" ]; then
    return
  fi
  xrandr --output "$(_xrandr_snd_mon)" --off
}
xrandr-disable () {
  while read -r device; do
    xrandr --output "$device" --off
  done < <(xrandr -q | tail -n +2 | grep -vE '^(e| )' | awk '{ print $1 }')
}



_firewardened-app () {
  set -x
  (firewarden "$@" 1>/dev/null 2>&1 & echo "$?")
  set +x
}

firewardened-firefox () {
  flags=()
  if [ "$1" = '-N' ]; then
    flags+=('-N')
    shift
  fi
  _firewardened-app "${flags[@]}" /usr/bin/firefox "$@"
}

firewardened-chromium () {
  flags=()
  disable_wasm=('--js-flags=--noexpose_wasm')
  if [ "$1" = '-N' ]; then
    flags+=('-N')
    shift
  fi
  if [ "$1" = '--wasm' ]; then
    disable_wasm=()
    shift
  fi
  _firewardened-app "${flags[@]}" /usr/bin/chromium --force-device-scale-factor=1.5 "${disable_wasm[@]}" "$@"
}


export PASSWORD_STORE_DIR=~/.password-store-private


edit-pacman-conf () {
  vim /etc/pacman.conf
}


edit-radare2-history () {
  vim -c ':$' ~/.cache/radare2/history
}
edit-rizin-history () {
  vim -c ':$' ~/.cache/rizin/history
}


# ---------------------------
# git helpers START
#

edit-firejail () {
  _edit-wrapper --dir ~/.config/firejail --overwrite-firejail "$1"
}


commit-firejail () {
  commit-in-dir ~/.config/firejail "$@"
}
commit-pacman-hooks () {
  commit-in-dir /etc/pacman.d/hooks "$@"
}


diff-etc () {
  _diff-wrapper /etc "$@"
}
diff-firejail () {
  _diff-wrapper ~/.config/firejail "$@"
}
diff-pacman-hooks () {
  _diff-wrapper /etc/pacman.d/hooks "$@"
}

status-firejail () {
  _status-wrapper ~/.config/firejail
}
status-pacman-hooks () {
  _status-wrapper /etc/pacman.d/hooks
}

reset-firejail () {
  _reset-wrapper ~/.config/firejail "$@"
}

#
# git helpers END
# ---------------------------


xinput-reverse-mouse-buttons () {
  if [ $# -lt 1 ]; then
    set -- "$(xinput list | grep Triathlon | tr '\t' ' ' | tr -s ' ' | cut -d ' ' -f6 | cut -d = -f2 | head -n1)"
  fi
  xinput set-button-map "$1" 3 2 1
}
xinput-reset-mouse-buttons () {
  if [ $# -lt 1 ]; then
    set -- "$(xinput list | grep Triathlon | tr '\t' ' ' | tr -s ' ' | cut -d ' ' -f6 | cut -d = -f2 | head -n1)"
  fi
  xinput set-button-map "$1" 1 2 3
}

yay_cache=~/.cache/yay
yay-generate-PKGBUILD-checksum () {

  local debug=''
  local no_fetch=''
  while [ $# -gt 0 ]; do
  key="$1"
    case "$key" in
      --debug)
      debug=true
      shift
      ;;

      --no-fetch)
      no_fetch=true
      shift
      ;;

      --)
      shift
      break
      ;;

      *)
      break
      ;;

    esac
  done


  local pkg_name="$1"
  output_file="$yay_cache"/"$pkg_name"-PKGBUILD.sha256sum
  if ! pushd "$yay_cache"/"$pkg_name"; then
    echo -e "${RED}[!] error on cd"
    return
  fi

  if [ -z "$no_fetch" ]; then
    set -x
    yay -G "$pkg_name" || return
    set +x
  fi

  if [ -n "$debug" ]; then
    ~/Documents/python/tools/archlinux-yay-remove-package-info.py PKGBUILD | vimn -
  else
    ~/Documents/python/tools/archlinux-yay-remove-package-info.py PKGBUILD | sha256sum > "$output_file"

  fi
  ls -alh "$output_file"
  popd >/dev/null 2>&1
}

_yay-update-based-on-checksum () {
  pkg_name="$1"

  if ~/Documents/python/tools/archlinux-yay-remove-package-info.py "$yay_cache"/"$pkg_name"/PKGBUILD | sha256sum | grep -f "$yay_cache"/"$pkg_name"-PKGBUILD.sha256sum; then
    echo >&2
    set -x
    yay --noconfirm -Sa "$pkg_name"
    set +x
  else
    set +x
    # shellcheck disable=SC1090
    source ~/Documents/scripts/source-me/colors.sh
    # shellcheck disable=SC2154
    echo -en "$RED" >&2
    echo     "[!] checksums do not match for \`$pkg_name\`." >&2
    # shellcheck disable=SC2154
    echo -e "     Not updating automatically!$NC" >&2
    exit 1
  fi
}



alias xclip='command xclip -selection clipboard'
alias xsel=xclip



gdb-gef () {
if [ -z "$NOT_HOST_ENV" ]; then
  gdb -q gef -x ~/.gef-startup "$@"
else
  gdb -q -ex gef "$@"
fi
}
gdb-p () {
  echo "$*" |\
    gdb -q  |\
    sed -r 's#.*= #\tresult: #g'
}
alias gdb-peda='gdb -q -ex peda'


redshift () {

  _help() {
cat <<EOF
USAGE: redshift COMMAND

COMMAND:
  on    ... enable redshift
  off   ... disable redshift
  reset ... enable based on current time
EOF
  }

  if [ $# -eq 0 ]; then
    _help
    return 1
  fi


while [ $# -gt 0 ]; do
key="$1"
  case "$key" in
    off)
    rm /tmp/redshift-on 2>/dev/null
    touch /tmp/redshift-off
    systemctl --user restart redshift.service

    return
    ;;

    on)
    rm /tmp/redshift-off 2>/dev/null
    touch /tmp/redshift-on
    systemctl --user restart redshift.service

    return
    ;;

    reset)
    rm /tmp/redshift-{off,on} 2>/dev/null
    systemctl --user restart redshift.service

    return
    ;;

    -h|--help)
    _help

    return
    ;;

    --)
    shift
    break
    ;;

    *)
    break
    ;;

  esac
done

}



mount-disable-cryttab-fstab () {
  args=()
  for i in "$@"; do
    args+=(! -name "$i")
  done

  while read -r line; do
    sudo systemd-umount "$line"
  done < <(set -x; find /tmp/automounts/ -mindepth 1 -maxdepth 1 -type d "${args[@]}"; set +x)

}
mount-enable-crypttab-fstab () {
  set -x
  sudo systemctl daemon-reload
  sudo systemctl restart cryptsetup.target
  sudo systemctl daemon-reload
  sudo systemctl restart local-fs.target
  set +x
}

