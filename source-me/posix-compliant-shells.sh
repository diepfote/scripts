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


  n_empty-trash () {
    local dir=~/.local/share/Trash
    if [ ! -e "$dir/files" ]; then
      return
    fi

    ls -alh "$dir"/files

    echo 'Do you want to empty the trash?'
    if yesno; then
      set -u
      rm -rf "${dir:?}"/****REMOVED***@***REMOVED***5.***REMOVED******REMOVED***@***REMOVED***5.***REMOVED***.com.udp
    sudo systemctl stop dhcpcd@wlp4s0.service
    sudo systemctl stop wpa_supplicant@wlp4s0.service
    set +x
  }

  xinput-reverse-mouse-buttons () {
    xinput set-button-map "$1" 3 2 1
  }
  xinput-reset-mouse-buttons () {
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
  command mpv "$1" 1>/dev/null 2>/dev/null &
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
    open_browser="$3"

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
  pkgbuild "$@" | vim -
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

  _rclone_verbose_sync_operation "$src" "$dst" "$@"
}


# nicked from https://leahneukirchen.org/dotfiles/bin/tarhash
tarhash () {
  # tarhash [--HASH] ARCHIVES... - hash files in archives without extracting

  HASH=sha1
  case "$1" in
    --md5|--rmd160|--sha1|--sha256|--sha384|--sha512) HASH=${1#--}; shift
  esac

    for archive; do
    bsdtar -cf - --format mtree --options mtree:$HASH @- <$archive |
      while read -r -A line; do
        [[ $line[-1] == ${HASH}digest=* ]] &&
          print "${line[-1]#${HASH}digest=}  ${(g:o:)line[1]}"
      done
  done
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
  work_repo_template "$1" git status -sb
}

status-dot-files () {
  _status-wrapper ~
}
status-function () {
  _status-wrapper ~/.config/fish/functions
}
status-go () {
  _status-wrapper ~/Documents/golang
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


work-sync () {

  if ! rclone_fastmail_sync_cheatsheets_from_remote --dry-run 2>&1 | ag --passthrough 'There was nothing to transfer'; then
    echo 'Do you want to trigger a sync?'
    if yesno; then
      rclone_fastmail_sync_cheatsheets_from_remote
    fi

  fi

  local conf_file=~/Documents/config/repo.conf
  local command='git pull'

  for repo_dir in $(cat "$conf_file"); do
    [ -z "$repo_dir" ] && continue  # skip empty lines

    work_repo_template "$repo_dir" $command
  done

}

work-checked-in () {
  __work-checked-in-wrapper ~/Documents/config/repo.conf
}


#
# git helpers END
# ---------------------------
