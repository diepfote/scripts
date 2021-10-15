export GIT_AUTHOR_NAME="$(read_toml_setting ~/Documents/config/git.conf name)"
export GIT_AUTHOR_EMAIL="$(read_toml_setting ~/Documents/config/git.conf email)"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"


export SYSTEMD_COLORS=0

# used in sniff & httpdump
export _ngrep_interface=wlp4s0

if [ -z "$IN_CONTAINER" ]; then
  _vpn_systemd_unit="$(read_toml_setting ~/Documents/config/vpn.conf vpn_systemd_unit)"
  export _vpn_systemd_unit
fi


_add_to_PATH "$HOME/Documents/scripts/bin/linux"  || true


# IP addresses
# shellcheck disable=SC2142
alias public-ip="drill myip.opendns.com @resolver1.opendns.com | awk '/IN\s+A\s+\w+/ { print \$5 }'"
# shellcheck disable=SC2142
alias local-ip="ip addr show dev wlp4s0 | awk '/inet/ { sub(/inet6? (addr:)? ?/, \"\"); print \$1 }'"
# shellcheck disable=SC2142
alias ips="ip addr |  awk '/inet/ { sub(/inet6? (addr:)? ?/, \"\"); print \$1 }'"


chromium () {
  (command chromium --force-device-scale-factor=1.5 "$@" 1>/dev/null 2>/dev/null &)
}

asm_dev () {
  local slides_open="$(ps -ef | grep zathura | grep 'OpSys_ASM')"
  local recommendation_open="$(ps -ef | grep zathura | grep -- 'pcasm-book')"

  if [ -z "$slides_open" ]; then
    xdg-open "$HOME"/Documents/books\ and\ documentation/reverse\ engineering\ re/assembly/*_OpSys_ASM.pdf
  fi

  if [ -z "$recommendation_open" ]; then
    xdg-open "$HOME/Documents/books and documentation/reverse engineering re/assembly/pcasm-book.pdf"
  fi

  if [ -z "$guide_open" ]; then
    xdg-open "$HOME/Documents/cheatsheets/assembly/Guide to x86 Assembly.pdf" >/dev/null 2>&1
  fi

  asm_dir=/home/$USER/Documents/asm
  cd "$asm_dir"
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

snap_all () {
  local vol_group_mapper=/dev/mapper/VolGroup00

  local d
  local dir
  local LVs=()

  d="$(date +%FT%T%Z)"
  d="${d//:/-}"


  while IFS='' read -r line; do
    LVs+=("$line")
  done < <(sudo lvs -o lv_name | tail -n +2 | awk '{ print $1 }' | sed -r '/[0-9]{4}/d')

  for dir in "${LVs[@]}"; do
    _snap "$dir" "$d"
  done
}

snap_subset () {
  local vol_group_mapper=/dev/mapper/VolGroup00

  local d
  local dir
  local size

  d="$(date +%FT%T%Z)"
  d="${d//:/-}"

  dir=home
  size='10GB'
  _snap "$dir" "$d" "$size"


  local dir=root
  local size='8GB'
  _snap "$dir" "$d" "$size"
}

snap-renew () {
  sudo lvremove -y /dev/VolGroup00/s_*; snap_subset
}


open_file_if_not_open () {
  local filename="$1"
  if [ -z "$(ps -ef | grep -v grep | grep "$(basename "$filename")")" ]; then
    xdg-open "$filename"  # xdg-open should be a function already
  fi
}

xdg-open () {
  (command xdg-open "$@" >/dev/null 2>&1 &)
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
  _firewardened-app /usr/bin/chromium --force-device-scale-factor=1.5 --js-flags=--noexpose_wasm "$@"
}


pacman-get-required-by-for-upgradeable () {
  _pacman-get-required-by-for-upgradeable () {
    pkgs=()

    while IFS='' read -r line; do
      pkgs+=( "$line" )
    done < <(pacman -Sup --print-format '%n')

    # no upgradable packages?
    if [ ${#pkgs[@]} -gt 0 ]; then
      echo "${pkgs[@]}" | xargs pacman -Qii 2>&1 | \
        grep -E '^\s*$|^Description|^Name|^Required By'
    fi
  }

  pkg_info=()

  while IFS='' read -r line; do
    pkg_info+=( "$line" )
  done < <(_pacman-get-required-by-for-upgradeable)

  if [ "${#pkg_info[@]}" -gt 1 ]; then
    # snatched from https://stackoverflow.com/a/15692004
    printf '%s\n' "${pkg_info[@]}" | vim -c 'set buftype=nofile' -
  fi
}


export PASSWORD_STORE_DIR=~/.password-store-private


commit-firejail () {
  commit-in-dir ~/.config/firejail "$@"
}
commit-pacman-hooks () {
  commit-in-dir /etc/pacman.d/hooks "$@"
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


do_sync () {
  echo
  echo Sync ***REMOVED***
  rsync -av ~/Videos/***REMOVED***/***REMOVED***_bluemchen/ "$(read_toml_setting ~/Documents/config/sync.conf ***REMOVED***)"

  echo
  echo Sync ***REMOVED***
  rsync -av ~/Videos/***REMOVED***/***REMOVED***_***REMOVED***UN***REMOVED***/ "$(read_toml_setting ~/Documents/config/sync.conf ***REMOVED***)"

  echo
  echo Sync yoga
  rsync -av ~/Videos/***REMOVED***/yoga/ "$(read_toml_setting ~/Documents/config/sync.conf yoga)"

  echo
  echo Sync ***REMOVED*** ***REMOVED***
  rsync -av ~/Videos/***REMOVED***/***REMOVED***_***REMOVED***-***REMOVED***_***REMOVED***-und***REMOVED***/ "$(read_toml_setting ~/Documents/config/sync.conf ***REMOVED***)"

  echo
  echo Sync Löwenzahn
  rsync -av ~/Videos/***REMOVED***/***REMOVED***/ "$(read_toml_setting ~/Documents/config/sync.conf ***REMOVED***)"

  echo
  echo Sync photos
  rsync -av ~/Documents/iphone_pictures/* "$(read_toml_setting ~/Documents/config/sync.conf photos)"

}


__stop_related_units_if_active ()
{
  local unit="$1"

  for unit_to_stop in $(systemctl list-units | command grep -E '^\s*openvpn-client' | command grep -v "$unit" | awk '{ print $1 }'); do
    set -x
    sudo systemctl stop "$unit_to_stop"
    set +x
  done
}

__restart_unit_if_inactive () {
  set +x
  local unit="$1"
  if [ ! "$(systemctl is-active "$unit")" = active ]; then
     sudo systemctl restart "$unit"
  fi
}

refresh-i3status () {
  killall -SIGUSR1 i3status
}

_enable-network () {
  set -x
  __restart_unit_if_inactive 'wpa_supplicant@wlp4s0.service'
  set -x
  __restart_unit_if_inactive 'dhcpcd@wlp4s0.service'
  set -x

  __stop_related_units_if_active "$_vpn_systemd_unit"
  __restart_unit_if_inactive "$_vpn_systemd_unit"
  set -x

  sleep 3

  vpn_file="/tmp/tmp.ping-success"

  counter=0
  while ! ping -c 2 -W .5 archlinux.org  >/dev/null 2>&1 ; do
    if [ "$counter" -gt 4 ]; then
      return
    fi

    rm "$vpn_file"
    sudo systemctl restart "$_vpn_systemd_unit"
    sleep .5

    ((counter=counter+1))
  done

  touch "$vpn_file"

  sleep 1.5
  refresh-i3status
  set +x
}

_disable-network () {
  set -x
  sudo systemctl stop "$_vpn_systemd_unit"
  sudo systemctl stop dhcpcd@wlp4s0.service
  sudo systemctl stop wpa_supplicant@wlp4s0.service

  refresh-i3status
  set +x
}

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


alias xclip='command xclip -selection clipboard'

