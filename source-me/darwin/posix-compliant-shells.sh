#!/usr/bin/env bash

_add_to_PATH "/usr/local/opt/coreutils/libexec/gnubin"  || true
_add_to_MANPATH "/usr/local/opt/coreutils/libexec/gnuman"  || true

_add_to_PATH "/usr/local/opt/findutils/libexec/gnubin"  || true
_add_to_MANPATH "/usr/local/opt/findutils/libexec/gnuman"  || true

_add_to_PATH "/usr/local/opt/gnu-sed/libexec/gnubin"  || true
_add_to_MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman"  || true

_add_to_PATH "/usr/local/opt/gawk/libexec/gnubin"  || true
_add_to_MANPATH "/usr/local/opt/gawk/libexec/gnuman"  || true


_add_to_PATH "/usr/local/opt/grep/libexec/gnubin"  || true
_add_to_MANPATH "/usr/local/opt/grep/libexec/gnuman"  || true

_add_to_PATH "/usr/local/opt/gnu-getopt/bin"  || true
_add_to_PATH "/usr/local/opt/gnu-getopt/share/man"  || true

# ADD THIS ONE BEFORE newer version --> export PATH="asdf:$PATH"
# otherwise 3.6 will end up being resolved first
#
# python 3.6
_add_to_PATH "$HOME/.pyenv/versions/3.6.13/bin"  || true
# python 3.8
_add_to_PATH "$HOME/.pyenv/versions/3.8.10/bin"  || true


# python 3.10 = default
python_310_path="/usr/local/opt/python@3.10/libexec/bin"
ln -sf "$python_310_path"/python "$python_310_path"/python3
_add_to_PATH "$python_310_path"  || true
_add_to_PATH "$HOME/Library/Python/3.10/bin"  || true
# export LDFLAGS="-L/usr/local/opt/python@3.10/lib:$LDFLAGS"
# export PKG_CONFIG_PATH="/usr/local/opt/python@3.10/lib/pkgconfig:$PKG_CONFIG_PATH"



# ruby compiler settings
_add_to_PATH "/usr/local/opt/ruby/bin"  || true
_add_to_PATH "$HOME/.gem/ruby/2.7.0/bin"  || true # user gem files
# export LDFLAGS="-L/usr/local/opt/ruby/lib:$LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/ruby/include:$CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"




export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8



alias yabai-disable-mouse-focus="sed -i -r 's/^(yabai.*(autofocus|follows_focus on))/# \1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd; (cd ~/; git checkout -- ~/.yabairc)"
alias yabai-enable-mouse-focus="sed -i -r 's/^# (yabai.*(autofocus|follows_focus on))/\1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd; (cd ~/; git checkout -- ~/.yabairc)"



# snatched from https://github.com/jessfraz/dotfiles/blob/b6571ea19f86733933395127d0eec52b75206ef9/.aliases#L92
# Flush Directory Service cache
alias flush-dns="dscacheutil -flushcache && killall -HUP mDNSResponder"


# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L58
# IP addresses
alias public-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local-ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"



# used in sniff & httpdump
export _ngrep_interface=en0




n_empty-trash () {
  local dir=~/.local/share/Trash
  if [ ! -e "$dir/files" ]; then
    return
  fi

  ls -alh "$dir"/files

  echo 'Do you want to empty the trash?'
  if yesno; then
    set -u
    rm -rf "${dir:?}"/*
    set +u
  fi
}


mute-active-microphone () {
  osascript -e "set volume input volume 0"
}

unmute-active-microphone () {
  osascript -e "set volume input volume 100"
}

open_mac-os_app () {
  local app="$1"
  shift
  open /Applications/"$app" -n --args "$@"
}


tmutil-compare-last-2-backups () {
  sudo tmutil listbackups |\
    tail -2 |\
    sed 's#.*#"/Volumes/Time Machine Backups/Backups.backupdb/'"$(hostname)"'/&"#' |\
    xargs tmutil-compare-2-backups
}


w-checked-in () {
  __work-checked-in-wrapper ~/Documents/config/work-repo.conf
}


w-git_execute_on_all_repos () {
  git_execute_on_all_repos -c ~/Documents/config/work-repo.conf -- "$@"
}

w-git-cleanup () {
  # run `pull` and `delete-gone-branches`
  w-git_execute_on_all_repos  git update
}


_add_to_PATH "$HOME/Documents/scripts/bin/darwin"  || true
_add_to_PATH "$HOME/Documents/scripts/kubernetes/bin"  || true
_add_to_PATH "$HOME/Documents/scripts/kubernetes/bin/darwin"  || true


export PASSWORD_STORE_DIR=~/.password-store-work

