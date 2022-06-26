#!/usr/bin/env bash

GIT_AUTHOR_NAME="$(read_toml_setting ~/Documents/config/git.conf name)"
GIT_AUTHOR_EMAIL="$(read_toml_setting ~/Documents/config/git.conf email)"
export GIT GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"


export SYSTEMD_COLORS=0

# used in sniff & httpdump
export _ngrep_interface=wlp4s0

if [ -z "$NOT_HOST_ENV" ]; then
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

snap_all () {
  local d dir regex vol_group_mapper

  vol_group_mapper=/dev/mapper/VolGroup00
  regex="$1"
  # workaround if no input -> set to bogus value to match all
  echo "${regex:=ASDFASDF}"  >/dev/null

  d="$(date +%FT%T%Z)"
  d="${d//:/-}"


  while IFS='' read -r line; do
    if [[ "$line" =~ $regex ]]; then
      # do not create snapshots
      #
      continue
    fi

    _snap "$line" "$d"
  done < <(sudo lvs -o lv_name | tail -n +2 | awk '{ print $1 }' | sed -r '/[0-9]{4}/d')

}

snap_subset () {
  regex='VirtualBox|Videos|containers|swap'
  snap_all "$regex"
}

snap-renew () {
  sudo lvremove -y /dev/VolGroup00/s_*
  snap_subset
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
        grep -E '^\s*$|^Description|^Name|^Required By|^Optional For'
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


edit_pacman_conf () {
  sudo nvim /etc/pacman.conf
}


edit_iptables_rules () {
  sudo nvim /etc/iptables/iptables.rules

  sudo systemctl restart iptables.service
}

edit_radare2_history () {
  vim -c ':$' ~/.cache/radare2/history

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
  _reset-wrapper ~/.config/firejail
}

#
# git helpers END
# ---------------------------


allow_all_outbound_traffic () {
  sudo sed -i -r 's/^.*(-A OUTPUT -j ACCEPT)/\1/g' /etc/iptables/iptables.rules
  sudo systemctl restart iptables.service
}


disallow_all_outbound_traffic () {
  deny_all_outbound_traffic
}
deny_all_outbound_traffic () {
  sudo sed -i -r 's/^(-A OUTPUT -j ACCEPT)/#\1/g' /etc/iptables/iptables.rules
  sudo systemctl restart iptables.service
}


__stop_related_units_if_active ()
{
  local unit="$1"

  while IFS='' read -r unit_to_stop; do
    set -x
    sudo systemctl stop "$unit_to_stop"
    set +x
  done < <(systemctl list-units | command grep -E '^\s*openvpn-client' | command grep -v "$unit" | awk '{ print $1 }')
}

__restart_unit_if () {
  local check="$1"  # e.g. 'is-active'
  local unit="$2"  # e.g. 'dhcpcd@wlp4s0.service'
  result=''
  result="$3"

  if [ -z "$result" ]; then
    result=inactive
  fi

  if [ "$(systemctl "$check" "$unit")" != "$result" ]; then
     sudo systemctl restart "$unit"
  fi
}

refresh-i3status () {
  killall -SIGUSR1 i3status
}

_disable-network () {
  set -x
  if [ "$_vpn_systemd_unit" != None ]; then
    sudo systemctl stop "$_vpn_systemd_unit"
  fi
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

yay_cache=~/.cache/yay
sed_command_yay_update_based_on_checksums='/^(pkg(ver|rel)=|(sha256|md5)sums[^\s]*=)/d'
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
  if ! cd "$yay_cache"/"$pkg_name"; then
    echo -e "${RED}[!] error on cd"
    return
  fi

  if [ -z "$no_fetch" ]; then
    set -x
    yay -G "$pkg_name" || return
    set +x
  fi

  if [ -n "$debug" ]; then
    sed -r "$sed_command_yay_update_based_on_checksums" PKGBUILD | vimn -
  else
    sed -r "$sed_command_yay_update_based_on_checksums" PKGBUILD | sha256sum > "$output_file"
  fi
  ls -alh "$output_file"
}

# add yay completion to os independent update script
source /usr/share/bash-completion/completions/yay
complete -F _yay pkg-update


alias xclip='command xclip -selection clipboard'
alias xsel=xclip


gdb-gef () {
if [ -z "$NOT_HOST_ENV" ]; then
  gdb -q gef -x ~/.gef-startup
else
  gdb -q -ex gef
fi
}
gdb-p () {
  echo "$*" |\
    gdb -q  |\
    sed -r 's#.*= #\tresult: #g'
}
alias gdb-peda='gdb -q -ex peda'

