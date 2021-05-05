#!/usr/bin/env bash

export EDITOR=nvim
export VISUAL=nvim


export MANPAGER=less
# colorize man pages with 'bat'
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"


# cannot use this any longer
# this breaks custom lesskey files
#
# export LESSSECURE=1
# readonly LESSSECURE

export GO111MODULE=off

export NNN_COLORS=2136  # use a different color for each context -> version >= 3.2
export NNN_TRASH=1
export NNN_BMS="d:~/Documents;h:~;D:~/Downloads;f:~/.config/fish/functions;s:~/Documents/scripts;L:~/Library/LaunchAgents;l:~/Documents/systemd-user;S:~/.config/systemd/user;E:/etc/;v:~/Videos;V:/run/media/$USER/large_drive/Media/Video-Files/Videos;m:~/Movies"  # jump locations for nnn
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;v:imgview;t:imgthumb'  # curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh


export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"


export BAT_STYLE=plain  # use change for + signs next to modifications --> git


# -------------------------
# files to source
source ~/Documents/scripts/source-me/colors.sh

# source fish functions
sh_functions_file=~/.sh_functions
[[ ! -f "$sh_functions_file" ]] && \
  ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"

# -------------------------



_add_to_PATH "$HOME/.bin"
_add_to_PATH "$HOME/go/bin"
_add_to_PATH "$HOME/Documents/scripts/bin"




# -------------------------
# OS specific START

if [ "$(uname)" = 'Darwin' ]; then

  export GIT_AUTHOR_NAME='Florian Begusch'
  export GIT_AUTHOR_EMAIL='florian.begusch@***REMOVED***.***REMOVED***.com'
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"


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

  # export LDFLAGS="-L/usr/local/opt/python@3.9/lib:$LDFLAGS"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.9/lib/pkgconfig:$PKG_CONFIG_PATH"

  # ruby compiler settings
  _add_to_PATH "/usr/local/opt/ruby/bin"
  _add_to_PATH "$HOME/.gem/ruby/2.7.0/bin"  # user gem files
  # export LDFLAGS="-L/usr/local/opt/ruby/lib:$LDFLAGS"
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


  alias yabai-disable-mouse-focus="sed -i -r 's/^(yabai.*(autofocus|follows_focus on))/# \1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd; (cd ~/; git checkout -- ~/.yabairc)"
  alias yabai-enable-mouse-focus="sed -i -r 's/^# (yabai.*(autofocus|follows_focus on))/\1/g' ~/.yabairc; brew services restart yabai; brew services restart skhd; (cd ~/; git checkout -- ~/.yabairc)"

  brew-leaves-required-by () {
    if [ -n "$BREW_REQUIRED_BY_LIST_INFO" ]; then
      BREW_REQUIRED_BY_LIST_INFO="$BREW_REQUIRED_BY_LIST_INFO" brew leaves | xargs brew-required-by
    else
      brew leaves | xargs brew-required-by
    fi
  }

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

  kill-jamf () {
    for pid in $(ps -ef | grep -i jamf | grep -v grep | tr -s ' ' | cut -d ' ' -f3); do
      set -x
      sudo kill -9 "$pid"
      set +x
    done
  }
  kill-symantec () {
    for pid in $(ps -ef | grep -Ei 'symantec|com.broadcom.mes.systemextension' | grep -v grep | awk '{ print $2 }'); do
      set -x
      sudo kill -9 "$pid"
      set +x
    done
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
    open /Applications/"$app" -n --args "$1" "$2"
  }

  tmutil-compare-last-2-backups () {
    sudo tmutil listbackups |\
      tail -2 |\
      sed 's/.*/"&"/' |\
      xargs  sudo tmutil compare
  }




  w-checked-in () {
    __work-checked-in-wrapper ~/Documents/config/work-repo.conf
  }


  w-git_execute_on_all_repos () {
    git_execute_on_all_repos "$1" ~/Documents/config/work-repo.conf
  }

  w-git-cleanup () {
   w-git-update
   w-git-delete-gone-branches
  }


  _add_to_PATH "$HOME/Documents/scripts/bin/darwin"
  _add_to_PATH "$HOME/Documents/scripts/kubernetes/bin"
  _add_to_PATH "$HOME/Documents/scripts/kubernetes/bin/darwin"


  export PASSWORD_STORE_DIR=~/.password-store-work

elif grep -L 'Arch Linux' /etc/os-release; then
  # Arch only | Arch Linux only | Archlinux only


  export GIT_AUTHOR_NAME='Florian Begusch'
  export GIT_AUTHOR_EMAIL='florian.begusch@gmail.com'
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"



  _add_to_PATH "$HOME/Documents/scripts/bin/linux"


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

  xdg-open () {
    (command xdg-open "$@" >/dev/null 2>&1 &)
  }

  _firewardened-app () {
    set -x
    (firewarden "$@" 1>/dev/null 2>&1 &)
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
    _firewardened-app /usr/bin/chromium --js-flags=--noexpose_wasm "$@"
  }


  pacman-get-required-by-for-upgradeable () {
    _pacman-get-required-by-for-upgradeable () {
      pkgs=()
      
      while IFS='' read -r line; do
        pkgs+=( "$line" )
      done < <(pacman -Sup --print-format '%n')

      # no upgradable packages?
      if [ ${#pkgs[@]} -gt 1 ]; then
        echo "${pkgs[@]}" | xargs pacman -Qii
      fi
    }

    pkg_info=()
    
    while IFS='' read -r line; do
      pkg_info+=( "$line" )
    done < <(_pacman-get-required-by-for-upgradeable)

    if [ "${#pkg_info[@]}" -gt 1 ]; then
      # snatched from https://stackoverflow.com/a/15692004
      printf '%s\n' "${pkg_info[@]}" | vim -c '/Required By' -
    fi
  }


  export PASSWORD_STORE_DIR=~/.password-store-private


  commit-firejail () {
    commit-in-dir /etc/firejail "$@"
  }
  commit-pacman-hooks () {
    commit-in-dir /etc/pacman.d/hooks "$@"
  }


  diff-firejail () {
    _diff-wrapper /etc/firejail "$@"
  }
  diff-pacman-hooks () {
    _diff-wrapper /etc/pacman.d/hooks "$@"
  }

  status-firejail () {
    _status-wrapper /etc/firejail
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
    rsync -av ~/Documents/iphone_pictures/****REMOVED***@***REMOVED***5.***REMOVED******REMOVED***@***REMOVED***5.***REMOVED***.com.udp
    sudo systemctl stop dhcpcd@wlp4s0.service
    sudo systemctl stop wpa_supplicant@wlp4s0.service
    set +x

    # refresh i3status
    killall -SIGUSR1 i3status
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

fi

# OS specific END
# -------------------------

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
# common functions START
#

mpv () {
  (command mpv "$1" 1>/dev/null 2>/dev/null &)
}


neomutt () {
  # ensure saved attachments end up in Downloads
  (cd ~/Downloads && command neomutt "$@")
}


dl-youtube () {
  set -x
  youtube-dl -f "$@"
  set +x
}

_dl-youtube-filter()
{
  set +u
  local url="$1"
  local filter_type="$2"
  local filter="$3"
  local message="$4"
  shift 4

  if [ -z "$1" ]; then
    local quality=best
  else
    quality="$1"
    shift
  fi
  local additional_args=("$@")
  set -u

  cmd=('dl-youtube' "$quality" '--print-json' "$filter_type" "$filter" '-w' '--add-metadata' "${additional_args[@]}" "$url")
  set -x
  if ! "${cmd[@]}" | jq ._filename; then
    quality=best  # re-run with best quality
    "${cmd[@]}" | jq ._filename
  set +x

  fi
}

dl-playlist () {
  first_arg="$1"
  shift

  set -x
  youtube-dl -f "$first_arg" "$@" \
    -o '%(playlist_title)s/%(playlist_index)s %(title)s-%(id)s.%(ext)s'
  set +x
}


ccat () {
  pygmentize -g "$@"
}

lessc () {
  ccat "$1" | less -R
}


pdf-extract-pages () {
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
     -dFirstPage="$3" -dLastPage="$4" \
     -sOutputFile="$2" "$1"
}

pdf-merge () {
  last_arg="${@:$#}"
  set -- "${@:1:$(($#-1))}"  # all except last

  set -x
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$last_arg" "$@"
  set +x
}


pkgbuild () {
  _get_pkgname () {
    echo "$1" | sed "s#.*/##"
  }

  _get_repo_type () {
    if echo "$1" | grep '/' 1>/dev/null 2>/dev/null; then
      echo "$1" | sed "s#/.*#/#"
    else
      echo aur/
    fi
  }

  _set_urls () {
    local aur_base_url='https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h='
    local core_base_url='https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/'
    local community_base_url='https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/'

    local browser_aur_base_url='https://aur.archlinux.org/packages/'
    local REPOTYPE_PLACEHOLDER=REPOTYPE
    local browser_main_base_url="https://www.archlinux.org/packages/$REPOTYPE_PLACEHOLDER"'x86_64/'

    local repo_type="$(_get_repo_type "$1")"
    local pkgname="$(_get_pkgname "$1")"

    echo -en "$RED" 1>&2; echo -e "repo type:$NC $repo_type" 1>&2

    case "$repo_type" in
      'extra/' | 'core/')
        url="$core_base_url$pkgname"
        browser_url="$(echo "$browser_main_base_url" | sed "s#$REPOTYPE_PLACEHOLDER#$repo_type#")"$pkgname")"
        ;;

      'multilib/' | 'community/')
        url="$community_base_url$pkgname"
        browser_url"$(echo "$browser_main_base_url" | sed "s#$REPOTYPE_PLACEHOLDER#$repo_type#")"$pkgname")"
        ;;

      'aur/' | '' | '*')
        url="$aur_base_url$pkgname"
        browser_url="$browser_aur_base_url$pkgname"
        ;;

      esac
  }

  if [ "$1" = -c ]; then
    no_pager=true
    set +u
    open_browser="$3"
    set -u

    _set_urls "$2"
  else
    open_browser="$2"

    _set_urls "$1"
  fi

  echo -en "$GREEN" 1>&2; echo -e "browser_url:$NC $browser_url" 1>&2
  if [ -n "$open_browser" ]; then
    call_browser "$browser_url"
  fi

  set -x
  if [ -n "$no_pager" ]; then
    curl -sL "$url"
  else
    curl -sL "$url" | lessc
  fi
  set +x

  unset url browser_url open_browser no_pager
}

pkgbuildv () {
  pkgbuild -c "$@" | vim -
}


rclone_fastmail_sync_bewerbungen_cvs_arbeitszeugnisse () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src=~/Documents/bewerbungen_cvs_arbeitszeugnisse/
  dst="$(echo 'fastmail:'"$username"'.fastmail.com/files/bewerbungen_cvs_arbeitszeugnisse/')"

  _rclone_verbose_sync_operation "$src" "$dst" "$@"
}

rclone_fastmail_sync_cheatsheets_from_remote () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src='fastmail:'"$username"'.fastmail.com/files/cheatsheets/'
  dst=~/Documents/cheatsheets/

  _rclone_verbose_sync_operation "$src" "$dst" "$@"
}

rclone_fastmail_sync_cheatsheets_to_remote () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src=~/Documents/cheatsheets/
  dst='fastmail:'"$username"'.fastmail.com/files/cheatsheets/'

  _rclone_verbose_sync_operation --delete-excluded "$src" "$dst" "$@"
}


# nicked from https://leahneukirchen.org/dotfiles/bin/zombies
list-zombies-and-parents () {
  ps -eo state,pid,ppid,comm | awk '
    { cmds[$2] = $NF }
    /^Z/ { print $(NF-1) "/" $2 " zombie child of " cmds[$3] "/" $3 }'
  }


#
# common functions END
# ---------------------------


# ---------------------------
# git helpers START
#

_checkout-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git checkout -- "$@"
}

checkout-dot-files () {
  _checkout-wrapper ~/ "$@"
}
checkout-function () {
  _checkout-wrapper ~/.config/fish/functions "$@"
}
checkout-go () {
  _checkout-wrapper ~/Documents/golang "$@"
}
checkout-python () {
  _checkout-wrapper ~/Documents/python "$@"
}
checkout-script () {
  _checkout-wrapper ~/Documents/scripts "$@"
}
checkout-vim () {
  _checkout-wrapper ~/.vim "$@"
}


commit-dot-files () {
  commit-in-dir ~ "$@"
}
commit-function () {
  commit-in-dir ~/.config/fish/functions "$@"
}
commit-go () {
  commit-in-dir ~/Documents/golang "$@"
}
commit-python () {
  commit-in-dir ~/Documents/python "$@"
}
commit-script () {
  commit-in-dir ~/Documents/scripts "$@"
}
commit-vim () {
  commit-in-dir ~/.vim "$@"
}


_diff-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git diff "$@"
}

diff-dot-files () {
  _diff-wrapper ~ "$@"
}
diff-function () {
  _diff-wrapper ~/.config/fish/functions "$@"
}
diff-go () {
  _diff-wrapper ~/Documents/golang "$@"
}
diff-python () {
  _diff-wrapper ~/Documents/python "$@"
}
diff-script () {
  _diff-wrapper ~/Documents/scripts "$@"
}
diff-vim () {
  _diff-wrapper ~/.vim "$@"
}

_log-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  work_repo_template "$dir" git l "$@"
}

log-dot-files () {
  _log-wrapper ~/ "$@"
}
log-function () {
  _log-wrapper ~/.config/fish/functions "$@"
}
log-go () {
  _log-wrapper ~/Documents/golang "$@"
}
log-python () {
  _log-wrapper ~/Documents/python "$@"
}
log-script () {
  _log-wrapper ~/Documents/scripts "$@"
}
log-vim () {
  _log-wrapper ~/.vim "$@"
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
  local dir="$1"
  shift

  work_repo_template "$dir" git status -sb "$@"
}

status-dot-files () {
  _status-wrapper ~ "$@"
}
status-function () {
  _status-wrapper ~/.config/fish/functions "$@"
}
status-go () {
  _status-wrapper ~/Documents/golang "$@"
}
status-python () {
  _status-wrapper ~/Documents/python "$@"
}
status-script () {
  _status-wrapper ~/Documents/scripts "$@"
}
status-vim () {
  _status-wrapper ~/.vim "$@"
}


_work-wrapper () {
  local conf_file="$1"
  shift
  local command=("$@")

  while read -r repo_dir; do
    [ -z "$repo_dir" ] && continue  # skip empty lines

    if [ "$repo_dir" = /etc ] || \
       [ "$repo_dir" = /etc/pacman.d/hooks ] || \
       [ "$repo_dir" = /etc/firejail ]; then
      if [ "${command[1]}" = pull ] || \
         [ "${command[1]}" = fetch ]; then
        # shellcheck disable=SC1090
        source ~/Documents/scripts/source-me/colors.sh
        echo "${RED}Only running fetch!$NC"
        command[1]=fetch
      fi
    fi

    work_repo_template "$repo_dir" "${command[@]}"
  done <"$conf_file"
  set +x
}

work-sync () {

  if ! rclone_fastmail_sync_cheatsheets_from_remote --dry-run 2>&1 | ag --passthrough 'There was nothing to transfer'; then
    echo 'Do you want to trigger a sync?'
    if yesno; then
      rclone_fastmail_sync_cheatsheets_from_remote
    fi

  fi


  local username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"

  if [ "$(uname)" = Darwin ]; then
    local fastmail_path='fastmail:'"$username"'.fastmail.com/files/-configs/arch'
    local dir=~/Documents/misc/arch
    [ ! -d "$dir" ] && mkdir -p "$dir"
  else
    local fastmail_path='fastmail:'"$username"'.fastmail.com/files/-configs/mac-os'
    local dir=~/Documents/misc/mac-os
  fi

  [ ! -d "$dir" ] && mkdir -p "$dir"
  _rclone_verbose_sync_operation "$fastmail_path" "$dir"


  local conf_file=~/Documents/config/repo.conf
  local command=('git' 'pull')

  _work-wrapper "$conf_file" "${command[@]}"
}

work_push () {
  local conf_file=~/Documents/config/repo.conf
  local command=('git' 'push')

  _work-wrapper "$conf_file" "${command[@]}"
}

work_fetch () {
  local conf_file=~/Documents/config/repo.conf
  local command=('git' 'fetch')

  _work-wrapper "$conf_file" "${command[@]}"
}

work-checked-in () {
  __work-checked-in-wrapper ~/Documents/config/repo.conf
}


#
# git helpers END
# ---------------------------
