#!/usr/bin/env bash

# reset exports
unset LDFLAGS CPPFLAGS PKG_CONFIG_PATH

source ~/Repos/scripts/source-me/darwin/common-functions.sh

_add_to_PATH "$(/opt/homebrew/opt/findutils/libexec/gnubin/find /opt/homebrew/Cellar/git/ -type d -name git-jump | head -n1)"

_add_to_PATH "/opt/homebrew/opt/coreutils/libexec/gnubin"
_add_to_MANPATH "/opt/homebrew/opt/coreutils/libexec/gnuman"

_add_to_PATH "/opt/homebrew/opt/findutils/libexec/gnubin"
_add_to_MANPATH "/opt/homebrew/opt/findutils/libexec/gnuman"

_add_to_PATH "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
_add_to_MANPATH "/opt/homebrew/opt/gnu-sed/libexec/gnuman"

_add_to_PATH "/opt/homebrew/opt/gawk/libexec/gnubin"
_add_to_MANPATH "/opt/homebrew/opt/gawk/libexec/gnuman"

_add_to_PATH "/opt/homebrew/opt/grep/libexec/gnubin"
_add_to_MANPATH "/opt/homebrew/opt/grep/libexec/gnuman"

_add_to_PATH "/opt/homebrew/opt/gnu-getopt/bin"
_add_to_MANPATH "/opt/homebrew/opt/gnu-getopt/share/man"

# ADD THIS ONE BEFORE newer version --> export PATH="asdf:$PATH"
# otherwise these python versions will be resolved before latest
#
# python 3.13
python_313_path="/opt/homebrew/opt/python@3.13/libexec/bin"
# ln -sf "$python_313_path"/python "$python_313_path"/python3
_add_to_PATH "$python_313_path"
# _add_to_PATH "$HOME/Library/Python/3.13/bin"
# export LDFLAGS="-L/opt/homebrew/opt/python@3.13/lib $LDFLAGS"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/python@3.13/lib/pkgconfig:$PKG_CONFIG_PATH"
#
# python 3.12
python_312_path="/opt/homebrew/opt/python@3.12/libexec/bin"
# ln -sf "$python_312_path"/python "$python_312_path"/python3
_add_to_PATH "$python_312_path"
# _add_to_PATH "$HOME/Library/Python/3.12/bin"
# export LDFLAGS="-L/opt/homebrew/opt/python@3.12/lib $LDFLAGS"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/python@3.12/lib/pkgconfig:$PKG_CONFIG_PATH"
#
# python 3.11 = default
python_311_path="/opt/homebrew/opt/python@3.11/libexec/bin"
# ln -sf "$python_311_path"/python "$python_311_path"/python3
_add_to_PATH "$python_311_path"
_add_to_PATH "$HOME/Library/Python/3.11/bin"
export LDFLAGS="-L/opt/homebrew/opt/python@3.11/lib $LDFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/python@3.11/lib/pkgconfig:$PKG_CONFIG_PATH"

_add_to_PATH ~/.venv/bin/
export LDFLAGS="-L$HOME/.venv/lib/ $LDFLAGS"
export PKG_CONFIG_PATH="$HOME/.venv/lib/pkgconfig:$PKG_CONFIG_PATH"

# pipx installed binaries
_add_to_PATH "$HOME/.local/bin"

_add_to_PATH "$HOME/Repos/scripts/private/bin/darwin"
_add_to_PATH "$HOME/Repos/scripts/bin/darwin"
_add_to_PATH "$HOME/Repos/scripts/kubernetes/bin"
_add_to_PATH "$HOME/Repos/scripts/kubernetes/bin/darwin"

_add_to_PATH "$HOME/.bazel/bin"
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# if you install something via `rustup component add <>` it ends up here
_add_to_PATH ~/.rustup/toolchains/stable-aarch64-apple-darwin/bin


# --
# ruby compiler settings
_add_to_PATH "/opt/homebrew/opt/ruby-build/bin"
_add_to_PATH "$HOME/.gem/ruby/2.7.0/bin"


# TODO maybe add ruby CPP Flag & PKG_CONFIG_PATH
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include:$CPPFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib $LDFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"
# --

_add_to_PATH /opt/homebrew/opt/node@22/bin
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/node@22/include:$CPPFLAGS"
# --

# --
# readline shared object was missing. so I added all exports recommended by the brew pkg

# $ pass asdf/blub -c
# dyld[54483]: Library not loaded: '/opt/homebrew/opt/readline/lib/libreadline.8.dylib'
#   Referenced from: '/opt/homebrew/Cellar/gnupg/2.3.7_1/bin/gpg'
#   Reason: tried: '/opt/homebrew/opt/readline/lib/libreadline.8.dylib' (no such file), '/opt/homebrew/lib/libreadline.8.dylib' (no such file), '/usr/lib/libreadline.8.dylib' (no such file)

export LDFLAGS="-L/opt/homebrew/opt/readline/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include:$CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig:$PKG_CONFIG_PATH"
# --


export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8


# snatched from https://github.com/itspriddle/dotfiles/blob/master/profile.d/env.sh
# Disable emoji when installing packages with Homebrew
export HOMEBREW_NO_EMOJI=1
# Opt-out of Analytics
export HOMEBREW_NO_ANALYTICS=1
# Disable homebrew autoupdate
export HOMEBREW_NO_AUTO_UPDATE=1
# Use git repos as installation source
export HOMEBREW_NO_INSTALL_FROM_API=1


# fix gpg error: `gpg: public key decryption failed: Inappropriate ioctl for device`
# snatched from https://stackoverflow.com/a/57591830
GPG_TTY="$(tty)"
export GPG_TTY


export PASSWORD_STORE_DIR=~/.password-store-work


# snatched from https://github.com/jessfraz/dotfiles/blob/b6571ea19f86733933395127d0eec52b75206ef9/.aliases#L92
# Flush Directory Service cache
alias flush-dns="dscacheutil -flushcache && sudo pkill -HUP mDNSResponder"


# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L58
# IP addresses
alias public-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local-ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"



# used in sniff & httpdump
export _ngrep_interface=en0


task () {
  # append is a native command btw
  if [ "$1" = prepend ]; then
    local id description
    id="$2"
    description="$(command task _get "$id".description)"
    command task modify "$id" "$3 $description"
  else
   command task "$@"
  fi
}


mute-active-microphone () {
  osascript -e "set volume input volume 0"
}

unmute-active-microphone () {
  osascript -e "set volume input volume 100"
}

# fix pulumi pop-ups
firewall-restart () {
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
}


open_mac-os_app () {
  local app="$1"
  shift
  open /Applications/"$app" -n --args "$@"
}


tmutil-compare-last-2-backups () {
  tmutil listbackups -m |\
  tail -2 |\
  sed "s#.*#'&'#" |\
  xargs tmutil-compare-2-backups
}

tmutil-delete-local-snapshots () {
  df -h
  sudo tmutil listlocalsnapshots /  | tail -n +2 | sed 's#com.apple.TimeMachine.##; s#.local##' | xargs -n 1 sudo tmutil deletelocalsnapshots
  df -h
}


python-clear-deploy-cache () {
  if [ $# -lt 1 ]; then
    set -- .
  fi
  set -x
  poetry cache clear --all --no-interaction -vv "$1"
  rm -rf ~/Library/Caches/pypoetry/{cache,artifacts}
  rm -rf ~/.pulumi
  rm -rf "$1"/.{venv,pulumi}
  set +x
}


dock-hide () {
  defaults write com.apple.dock autohide -bool true && killall Dock
}
dock-unhide () {
  defaults write com.apple.dock autohide -bool false && killall Dock
}

w-checked-in () {
  ~/Repos/scripts/checked-in.sh work-repo.conf
}


