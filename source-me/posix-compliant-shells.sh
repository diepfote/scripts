#!/usr/bin/env bash

export EDITOR=nvim
export VISUAL=nvim

export LESSSECURE=1
readonly LESSSECURE

export NNN_COLORS=2136  # use a different color for each context -> version >= 3.2
export NNN_TRASH=1
export NNN_BMS="d:~/Documents;h:~;D:~/Downloads;f:~/.config/fish/functions;s:~/Documents/scripts;L:~/Library/LaunchAgents;l:~/Documents/systemd-user;S:~/.config/systemd/user;E:/etc/;v:~/Videos;V:/run/media/$USER/large_drive/Media/Video-Files/Videos;m:~/Movies"  # jump locations for nnn
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;v:imgview;t:imgthumb'  # curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh


export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"


_add_to_PATH "$HOME/.bin"
_add_to_PATH "$HOME/go/bin"
_add_to_PATH "$HOME/Documents/scripts/bin"


# -------------------------
# OS specific START

if [ "$(uname)" = 'Darwin' ]; then

  _add_to_PATH "/usr/local/opt/coreutils/libexec/gnubin"
  _add_to_PATH "/usr/local/opt/findutils/libexec/gnubin"
  _add_to_PATH "/usr/local/opt/gnu-sed/libexec/gnubin"
  _add_to_PATH "/usr/local/opt/grep/libexec/gnubin"

  # ADD THIS ONE BEFORE newer version --> export PATH="asdf:$PATH"
  # otherwise 3.6 will end up being resolved first
  #
  # pyenv version 3.6
  _add_to_PATH "$HOME/.pyenv/versions/3.6.12/bin"

  # python 3.9 = default
  python_39_path="/usr/local/opt/python@3.9/libexec/bin"
  ln -sf "$python_39_path"/python "$python_39_path"/python3
  _add_to_PATH "$python_39_path"
  _add_to_PATH "$HOME/Library/Python/3.9/bin"

  export LDFLAGS="-L/usr/local/opt/python@3.9/lib:$LDFLAGS"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.9/lib/pkgconfig:$PKG_CONFIG_PATH"

  # ruby compiler settings
  _add_to_PATH "/usr/local/opt/ruby/bin"
  _add_to_PATH "$HOME/.gem/ruby/2.7.0/bin"  # user gem files
  export LDFLAGS="-L/usr/local/opt/ruby/lib:$LDFLAGS"
  export CPPFLAGS="-I/usr/local/opt/ruby/include:$CPPFLAGS"
  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"




  export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8

  alias tss-pass='pass ***REMOVED***D***/***REMOVED*** -c'
  alias tss-user='pass ***REMOVED***D***/***REMOVED*** | tail -n 1 | pbcopy'
  alias ***REMOVED***_***REMOVED***pass='pass ***REMOVED***D***/***REMOVED***passwords/***REMOVED*** -c'
  alias bb_***REMOVED***_pass='pass ***REMOVED***D*** -c'


  alias openstack='HTTPS_PROXY="socks5://localhost:5555" openstack'
  alias terraform='HTTPS_PROXY="socks5://localhost:5555" terraform'


  alias yabai-disable-mouse-focus="sed -i -r 's/^(yabai.*(autofocus|follows_focus on))/# \1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd"
  alias yabai-enable-mouse-focus="sed -i -r 's/^# (yabai.*(autofocus|follows_focus on))/\1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd"


  stop-jamf () {
    for pid in $(ps -ef | grep -i jamf | grep -v grep | tr -s ' ' | cut -d ' ' -f3); do
      set -x
      sudo kill -9 "$pid"
      set +x
    done
  }

  _add_to_PATH "$HOME/Documents/scripts/bin/darwin"

  export PASSWORD_STORE_DIR=~/.password-store-work

elif grep -L 'Arch Linux' /etc/os-release; then
  # Arch only | Arch Linux only | Archlinux only

  pacman-get-required-by-for-upgradeable () {
    _pacman-get-required-by-for-upgradeable () {
      pacman -Sup --print-format '%n' | xargs pacman -Qii
    }
    _pacman-get-required-by-for-upgradeable | vim -c 'v/\v(Required By |Name |^$)/d' -
  }


  export PASSWORD_STORE_DIR=~/.password-store-private
fi

# OS specific END
# -------------------------


mpv () {
  command mpv "$1" 1>/dev/null 2>/dev/null &
}


w-git_execute_on_all_repos () {
  git_execute_on_all_repos "$1" ~/Documents/config/work-repo.conf
}

w-git-cleanup () {
 w-git-update
 w-git-delete-gone-branches
}

dl-youtube () {
  set -x
  youtube-dl -f $@
  set +x
}


dl-playlist () {
  first_arg="$1"
  second_arg="$2"
  set -- "${@:2:$(($#))}"; # drop first and second arg

  set -x
  youtube-dl -f "$first_arg" "$@" \
    -o '%(playlist_title)s/%(playlist_index)s %(title)s-%(id)s.%(ext)s' \
    "$second_arg"
  set +x
}

# -------------------------
# common aliases START
#

alias ls='ls --color=auto'

alias grep='grep --exclude-dir=.git \
                 --exclude-dir=.tox \
                 --exclude-dir=.venv \
                 --color'

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR="$(cat $HOME/.rangerdir)"; cd "$LASTDIR"'

alias git_goto_toplevel='cd "$(git rev-parse --show-toplevel)"'

alias formats-youtube-dl='youtube-dl -F'

type nvim 1>/dev/null 2>/dev/null  && alias vim=nvim
alias vimy="vim -c ':set ft=yaml'"
alias vimj="vim -c ':set ft=json'"


# pipenv aliases
alias pipsh="pipenv shell"


# common aliases END
# -------------------------


# ---------------------------
# git repo helpers START
#

_checkout-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git checkout -- $@
}

checkout-dot-files () {
  _checkout-wrapper ~/ $@
}
checkout-function () {
  _checkout-wrapper ~/.config/fish/functions $@
}
checkout-go () {
  _checkout-wrapper ~/Documents/golang $@
}
checkout-python () {
  _checkout-wrapper ~/Documents/python $@
}
checkout-script () {
  _checkout-wrapper ~/Documents/scripts $@
}
checkout-vim () {
  _checkout-wrapper ~/.vim $@
}

_diff-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git diff $@
}

diff-dot-files () {
  _diff-wrapper ~ $@
}
diff-firejail () {
  _diff-wrapper /etc/firejail $@
}
diff-function () {
  _diff-wrapper ~/.config/fish/functions $@
}
diff-go () {
  _diff-wrapper ~/Documents/golang $@
}
diff-pacman-hooks () {
  _diff-wrapper /etc/pacman.d/hooks $@
}
diff-python () {
  _diff-wrapper ~/Documents/python $@
}
diff-script () {
  _diff-wrapper ~/Documents/scripts $@
}
diff-vim () {
  _diff-wrapper ~/.vim $@
}

_log-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git l $@
}

log-dot-files () {
  _log-wrapper ~/ $@
}
log-function () {
  _log-wrapper ~/.config/fish/functions $@
}
log-go () {
  _log-wrapper ~/Documents/golang $@
}
log-python () {
  _log-wrapper ~/Documents/python $@
}
log-script () {
  _log-wrapper ~/Documents/scripts $@
}
log-vim () {
  _log-wrapper ~/.vim $@
}

_reset-wrapper () {
  work_repo_template "$1" git reset --hard
  work_repo_template "$1" git clean -df
}

reset-dot-files () {
 _reset-wrapper ~/
}
reset-function () {
 _reset-wrapper ~/.config/fish/functions
}
reset-go () {
 _reset-wrapper ~/Documents/golang
}
reset-python () {
 _reset-wrapper ~/Documents/python
}
reset-script () {
 _reset-wrapper ~/Documents/scripts
}
reset-vim () {
 _reset-wrapper ~/.vim
}

_status-wrapper () {
  work_repo_template "$1" git status -sb
}

status-dot-files () {
  _status-wrapper ~
}
status-firejail () {
  _status-wrapper /etc/firejail
}
status-function () {
  _status-wrapper ~/.config/fish/functions
}
status-go () {
  _status-wrapper ~/Documents/golang
}
status-pacman-hooks () {
  _status-wrapper /etc/pacman.d/hooks
}
status-python () {
  _status-wrapper ~/Documents/python
}
status-script () {
  _status-wrapper ~/Documents/scripts
}
status-vim () {
  _status-wrapper ~/.vim
}

#
# git repo helpers END
# ---------------------------




# -------------------------
# files to source
source ~/Documents/scripts/source-me/colors.sh

# source fish functions
sh_functions_file=~/.sh_functions
[[ ! -f "$sh_functions_file" ]] && \
  ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"

# -------------------------

