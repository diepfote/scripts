#!/usr/bin/env bash

source ~/Documents/scripts/source-me/darwin/common-functions.sh

_add_to_PATH /usr/local/Cellar/git/2.39.2/*/git-core/contrib/git-jump/

_add_to_PATH "/usr/local/opt/coreutils/libexec/gnubin"
_add_to_MANPATH "/usr/local/opt/coreutils/libexec/gnuman"

_add_to_PATH "/usr/local/opt/findutils/libexec/gnubin"
_add_to_MANPATH "/usr/local/opt/findutils/libexec/gnuman"

_add_to_PATH "/usr/local/opt/gnu-sed/libexec/gnubin"
_add_to_MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman"

_add_to_PATH "/usr/local/opt/gawk/libexec/gnubin"
_add_to_MANPATH "/usr/local/opt/gawk/libexec/gnuman"


_add_to_PATH "/usr/local/opt/grep/libexec/gnubin"
_add_to_MANPATH "/usr/local/opt/grep/libexec/gnuman"

_add_to_PATH "/usr/local/opt/gnu-getopt/bin"
_add_to_MANPATH "/usr/local/opt/gnu-getopt/share/man"

# ADD THIS ONE BEFORE newer version --> export PATH="asdf:$PATH"
# otherwise these python versions will be resolved before latest
#
# python 3.8
python_38_path="/usr/local/opt/python@3.8/libexec/bin"
_add_to_PATH "$python_38_path"


# python 3.11 = default
python_311_path="/usr/local/opt/python@3.11/libexec/bin"
ln -sf "$python_311_path"/python "$python_311_path"/python3
_add_to_PATH "$python_311_path"
_add_to_PATH "$HOME/Library/Python/3.11/bin"
export LDFLAGS="-L/usr/local/opt/python@3.11/lib:$LDFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/python@3.11/lib/pkgconfig:$PKG_CONFIG_PATH"


# pipx installed binaries
_add_to_PATH "$HOME/.local/bin"


# --
# ruby compiler settings
_add_to_PATH "/usr/local/opt/ruby-build/bin"
_add_to_PATH "$HOME/.gem/ruby/2.7.0/bin"

export CPPFLAGS="-I/usr/local/opt/openssl@3/include:$CPPFLAGS"
export CPPFLAGS="-I/usr/local/opt/ruby/include:$CPPFLAGS"

export LDFLAGS="-L/usr/local/opt/openssl@3/lib:$LDFLAGS"
export LDFLAGS="-L/usr/local/opt/ruby/lib:$LDFLAGS"

export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"
# --


# --
# readline shared object was missing. so I added all exports recommended by the packages

# $ pass asdf/blub -c
# dyld[54483]: Library not loaded: '/usr/local/opt/readline/lib/libreadline.8.dylib'
#   Referenced from: '/usr/local/Cellar/gnupg/2.3.7_1/bin/gpg'
#   Reason: tried: '/usr/local/opt/readline/lib/libreadline.8.dylib' (no such file), '/usr/local/lib/libreadline.8.dylib' (no such file), '/usr/lib/libreadline.8.dylib' (no such file)


  # readline is keg-only, which means it was not symlinked into /usr/local,
  # because macOS provides BSD libedit.

  # For compilers to find readline you may need to set:
  #   export LDFLAGS="-L/usr/local/opt/readline/lib"
  #   export CPPFLAGS="-I/usr/local/opt/readline/include"

  # For pkg-config to find readline you may need to set:
  #   export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"

export LDFLAGS="-L/usr/local/opt/readline/lib:$LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/readline/include:CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig:$PKG_CONFIG_PATH"
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

# fix gpg error: `gpg: public key decryption failed: Inappropriate ioctl for device`
# snatched from https://stackoverflow.com/a/57591830
GPG_TTY="$(tty)"
export GPG_TTY


alias yabai-disable-mouse-focus="sed -i -r 's/^(yabai.*(autofocus|follows_focus on))/# \1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd; (cd ~/; git checkout -- ~/.yabairc)"
alias yabai-layout-stack="yabai -m space --layout stack"
alias yabai-layout-bsp="yabai -m space --layout bsp"


# snatched from https://github.com/jessfraz/dotfiles/blob/b6571ea19f86733933395127d0eec52b75206ef9/.aliases#L92
# Flush Directory Service cache
alias flush-dns="dscacheutil -flushcache && sudo pkill -HUP mDNSResponder"


# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L58
# IP addresses
alias public-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local-ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"


alias k=kubectl


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


w-checked-in () {
  __work-checked-in-wrapper ~/Documents/config/work-repo.conf
}


w-git_execute_on_all_repos () {
  git_execute_on_all_repos -c ~/Documents/config/work-repo.conf -- "$@"
}

_add_to_PATH "$HOME/Documents/scripts/bin/darwin"
_add_to_PATH "$HOME/Documents/scripts/kubernetes/bin"
_add_to_PATH "$HOME/Documents/scripts/kubernetes/bin/darwin"


export PASSWORD_STORE_DIR=~/.password-store-work

