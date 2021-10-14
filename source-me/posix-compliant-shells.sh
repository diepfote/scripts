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

# TODO remove?
export GO111MODULE=off

export NNN_COLORS=2136  # use a different color for each context -> version >= 3.2
export NNN_TRASH=1
export NNN_BMS="d:~/Documents;h:~;D:~/Downloads;f:~/.config/fish/functions;s:~/Documents/scripts;L:~/Library/LaunchAgents;l:~/Documents/systemd-user;S:~/.config/systemd/user;E:/etc/;v:~/Videos;V:/run/media/$USER/large_drive/Media/Video-Files/Videos;m:~/Movies"  # jump locations for nnn
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;v:imgview;t:imgthumb'  # curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh


export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"


export BAT_STYLE=plain  # use change for + signs next to modifications --> git



# shellcheck disable=SC1090
source ~/Documents/scripts/source-me/colors.sh

# source fish functions
# TODO remove
sh_functions_file=~/.sh_functions
# shellcheck disable=SC1090
source "$sh_functions_file" || fish -c generate_sh_functions_to_call_fish_shell_functions





_add_to_PATH "$HOME/.bin"  || true
_add_to_PATH "$HOME/go/bin"  || true
_add_to_PATH "$HOME/.cargo/bin"  || true
_add_to_PATH "$HOME/Documents/scripts/bin"  || true



# -------------------------
# common aliases START
#

alias cheat='~/Documents/scripts/cheat.sh ~/Documents/cheatsheets'

alias ls='ls --color=auto'

alias grep='grep --exclude-dir=.git \
                 --exclude-dir=.helm \
                 --exclude-dir=.tox \
                 --exclude-dir=.mypy_cache \
                 --exclude-dir=.eggs \
                 --exclude-dir=*.egg-info \
                 --exclude-dir=*venv* \
                 --exclude-dir=_build \
                 --exclude-dir=__pycache__ \
                 --exclude-dir=.pytest_cache \
                 --exclude-dir=htmlcov \
                 --exclude=Session.vim \
                 --color'

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR="$(cat $HOME/.rangerdir)"; cd "$LASTDIR"'

alias git_goto_toplevel='cd "$(git rev-parse --show-toplevel)"'

alias formats-youtube-dl='youtube-dl -F'

type nvim 1>/dev/null 2>/dev/null  && alias vim=nvim
alias vimy="vim -c 'set buftype=nofile' -c ':set ft=yaml'"
alias vimj="vim -c 'set buftype=nofile' -c ':set ft=json'"


# pipenv aliases
alias pipsh="pipenv shell"


# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L145
# Reload the shell (i.e. invoke as a login shell)
# shellcheck disable=SC2139
alias reload="exec ${SHELL}"

# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L148
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'


# snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L126
# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"


# common aliases END
# -------------------------


# ---------------------------
# common functions START
#

mpv () {
  (command mpv "$@" 1>/dev/null 2>/dev/null &)
}


video-sync () {
  local dir
  dir=~/Movies
  if [ "$(uname)" != Darwin ]; then
    dir=~/Videos
  fi

  ~/Documents/scripts/normal-privileges_systemd_scripts/report-videos.sh

  echo
  ~/Documents/golang/tools/video-syncer/video-syncer "$dir"
  echo

  ~/Documents/scripts/normal-privileges_systemd_scripts/report-videos.sh
}


get-yt-links-for-downloads () {
  find "$1" -mindepth 1 | sed -r 's|(.*)([A-z0-9-]{11})\.[A-z0-9]{2,6}|\2 #  \1|
                                  /^\s*$/d
                                  s#^#https://youtu.be/#'
}


_link-shared-password-store () {

    if [ -z "$PASSWORD_STORE_DIR" ]; then
      echo -en "$RED"; echo -e "[!] unable to link files.$NC\n    PASSWORD_STORE_DIR variable empty!"
      exit 1
    fi


    # ensure all subdirectories exist to be able to link
    # files into them
    find ~/.password-store -path ~/.password-store/.git -prune -o -type d \
         -exec sh -c \ 'mkdir -p "$(echo "$0" | sed "s#.*password-store#$PASSWORD_STORE_DIR#")" ' {} \;


    find ~/.password-store -path ~/.password-store/.git -prune -o -regextype posix-egrep -regex '.*\.(bash|gpg)' \
         -exec sh -c 'ln -sf "$0" "$(echo "$0" | sed "s#.*password-store#$PASSWORD_STORE_DIR#")"' {} \;

}


# snatched from https://github.com/jessfraz/dotfiles/blob/b6571ea19f86733933395127d0eec52b75206ef9/.aliases#L86
# View HTTP traffic
alias sniff="sudo ngrep -d \"\$_ngrep_interface\" -t '^(GET|POST) ' 'tcp and port 80'"
# shellcheck disable=SC2139
alias httpdump="sudo tcpdump -i \"\$_ngrep_interface\" -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""


allow_all_outbound_traffic () {
  sudo sed -i 's/#-A OUTPUT -j ACCEPT/-A OUTPUT -j ACCEPT/g' /etc/iptables/iptables.rules
  sudo systemctl restart iptables.service
}


disallow_all_outbound_traffic () {
  deny_all_outbound_traffic
}
deny_all_outbound_traffic () {
  sudo sed -i 's/-A OUTPUT -j ACCEPT/#-A OUTPUT -j ACCEPT/g' /etc/iptables/iptables.rules
  sudo systemctl restart iptables.service
}

# get word definition
def () {
  dict -d gcide "$1" | lessc
}

doi_view () {
  #firefox --private-window "https://doi.org/$1"
  call_browser "https://doi.org/$1"
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


rclone_fastmail_sync_bewerbungen_cvs_arbeitszeugnisse () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src=~/Documents/bewerbungen_cvs_arbeitszeugnisse/
  dst='fastmail:'"$username"'.fastmail.com/files/bewerbungen_cvs_arbeitszeugnisse/'

  _rclone_verbose_sync_operation "$@" "$src" "$dst"
}

rclone_fastmail_sync_cheatsheets_from_remote () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src='fastmail:'"$username"'.fastmail.com/files/cheatsheets/'
  dst=~/Documents/cheatsheets/

  _rclone_verbose_sync_operation --delete-excluded "$@" "$src" "$dst"
}

rclone_fastmail_sync_cheatsheets_to_remote () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src=~/Documents/cheatsheets/
  dst='fastmail:'"$username"'.fastmail.com/files/cheatsheets/'

  _rclone_verbose_sync_operation --delete-excluded "$@" "$src" "$dst"
}


# nicked from https://leahneukirchen.org/dotfiles/bin/zombies
list-zombies-and-parents () {
  ps -eo state,pid,ppid,comm | awk '
    { cmds[$2] = $NF }
    /^Z/ { print $(NF-1) "/" $2 " zombie child of " cmds[$3] "/" $3 }'
  }


***REMOVED***_***REMOVED***_***REMOVED***UndTina_download () {
  ~/Documents/scripts/normal-privileges_systemd_scripts/***REMOVED***--***REMOVED***_***REMOVED***UN***REMOVED***.sh
}


edit-bash-history () {
  # :$ to start at the end of the file
  vim -c ':$' ~/.bash_history
}


new-docker () {
  edit-docker "$@"
}
new-mutt () {
  edit-mutt "$@"
}


edit-docker () {
  _edit-wrapper --dir ~/Documents/dockerfiles "$1"
}
edit-mutt () {
  _edit-wrapper --dir ~/.mutt "$1"
}
edit-go () {
  _edit-wrapper --dir ~/Documents/golang/tools "$1"
}
edit-python () {
  _edit-wrapper --dir ~/Documents/python/tools "$1"
}
edit-function () {
  _edit-wrapper --dir ~/.config/fish/functions "$1"
}
edit-firejail () {
  _edit-wrapper --dir ~/.config/firejail --overwrite-firejail "$1"
}
edit-vim () {
  _edit-wrapper --dir ~/.vim "$1"
}

_edit-wrapper () {
  if [ $# -eq 0 ]; then
    _help
    exit
  fi

  # Parse arguments
  positional_args=()
  OVERWRITE_FIREJAIL=''
  while [ $# -gt 0 ]; do
  key="$1"
    case "$key" in
      --overwrite-firejail)
      OVERWRITE_FIREJAIL=true
      shift
      ;;

      -d|--dir)
      DIR="$2"
      shift 2
      ;;

      -h|--help)
      _help
      exit 0
      ;;

      *) # unknown option
      positional_args+=("$1") # save in an array for later
      shift
      ;;
    esac
  done
  set -- "${positional_args[@]}"

  command=('vim')
  if [ -n "$OVERWRITE_FIREJAIL" ]; then
    command=('/usr/bin/nvim')
  fi

  "${command[@]}" "$DIR"/"$1"
}


#
# common functions END
# ---------------------------


# ---------------------------
# git helpers START
#

_checkout-wrapper () {
  local dir="$1"
  shift

  work_repo_template -d "$dir" git checkout -- "$@"
}

checkout-dot-files () {
  _checkout-wrapper ~/ "$@"
}
checkout-function () {
  _checkout-wrapper ~/.config/fish/functions "$@"
}
checkout-docker () {
  _checkout-wrapper ~/Documents/dockerfiles "$@"
}
checkout-mutt () {
  _checkout-wrapper ~/.mutt "$@"
}
checkout-go () {
  _checkout-wrapper ~/Documents/golang/tools "$@"
}
checkout-python () {
  _checkout-wrapper ~/Documents/python/tools "$@"
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
commit-docker () {
  commit-in-dir ~/Documents/dockerfiles "$@"
}
commit-mutt () {
  commit-in-dir ~/.mutt "$@"
}
commit-go () {
  commit-in-dir ~/Documents/golang/tools "$@"
}
commit-python () {
  commit-in-dir ~/Documents/python/tools "$@"
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

  work_repo_template -d "$dir" git diff "$@"
}

diff-dot-files () {
  _diff-wrapper ~ "$@"
}
diff-function () {
  _diff-wrapper ~/.config/fish/functions "$@"
}
diff-docker () {
  _diff-wrapper ~/Documents/dockerfiles "$@"
}
diff-mutt () {
  _diff-wrapper ~/.mutt "$@"
}
diff-go () {
  _diff-wrapper ~/Documents/golang/tools "$@"
}
diff-python () {
  _diff-wrapper ~/Documents/python/tools "$@"
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

  work_repo_template -d "$dir" git l "$@"
}

log-dot-files () {
  _log-wrapper ~/ "$@"
}
log-function () {
  _log-wrapper ~/.config/fish/functions "$@"
}
log-docker () {
  _log-wrapper ~/Documents/dockerfiles "$@"
}
log-mutt () {
  _log-wrapper ~/.mutt "$@"
}
log-go () {
  _log-wrapper ~/Documents/golang/tools "$@"
}
log-python () {
  _log-wrapper ~/Documents/python/tools "$@"
}
log-script () {
  _log-wrapper ~/Documents/scripts "$@"
}
log-vim () {
  _log-wrapper ~/.vim "$@"
}

_reset-wrapper () {
  work_repo_template -d "$1" git reset --hard
  work_repo_template -d "$1" git clean -df
}

reset-dot-files () {
  _reset-wrapper ~/
}
reset-function () {
  _reset-wrapper ~/.config/fish/functions
}
reset-docker () {
  _reset-wrapper ~/Documents/dockerfiles
}
reset-mutt () {
  _reset-wrapper ~/.mutt
}
reset-go () {
  _reset-wrapper ~/Documents/golang/tools
}
reset-firejail () {
  _reset-wrapper ~/.config/firejail
}
reset-python () {
  _reset-wrapper ~/Documents/python/tools
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

  work_repo_template -d "$dir" git status -sb "$@"
}

status-dot-files () {
  _status-wrapper ~ "$@"
}
status-function () {
  _status-wrapper ~/.config/fish/functions "$@"
}
status-docker () {
  _status-wrapper ~/Documents/dockerfiles "$@"
}
status-mutt () {
  _status-wrapper ~/.mutt "$@"
}
status-go () {
  _status-wrapper ~/Documents/golang/tools "$@"
}
status-python () {
  _status-wrapper ~/Documents/python/tools "$@"
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
       [ "$repo_dir" = /etc/pacman.d/hooks ]; then
      if [ "${command[1]}" = pull ] || \
         [ "${command[1]}" = fetch ]; then
        # shellcheck disable=SC1090
        source ~/Documents/scripts/source-me/colors.sh
        echo "${RED}Only running fetch!$NC"
        command[1]=fetch
      fi
    fi

    work_repo_template -d "$repo_dir" "${command[@]}"
  done <"$conf_file"
  set +x
}

work-sync () {
  # skip sync if output does not "Skipped "
  if rclone_fastmail_sync_cheatsheets_from_remote --dry-run  2>&1 | ag --passthrough 'Skipped ' ; then

    echo 'Do you want to trigger a sync?'
    if yesno; then
      rclone_fastmail_sync_cheatsheets_from_remote
    fi
  fi

  set +x
  local username
  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"

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

  echo 'Do you want to run video-syncer?'
  if yesno; then
    video-sync
  fi
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
  __work-checked-in-wrapper ~/Documents/config/repo.conf "$@"
}


#
# git helpers END
# ---------------------------
