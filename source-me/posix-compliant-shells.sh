#!/usr/bin/env bash
# shellcheck disable=SC1090

# set xxx to empty string if unset
echo ${TMUX:=''} >/dev/null
echo ${BASH_SOURCE_IT:=''} >/dev/null
echo ${TMUX_FAILURE:=''} >/dev/null

if [[ "$(hostname)" =~ ^[a-z0-9]+$ ]] ||\
   [ "$(hostname)" = docker-desktop ] || \
   [[ "$(hostname)" =~ lima* ]] || \
   [ "$(id -u --name 2>/dev/null)" = build-user ]; then
  export NOT_HOST_ENV=true
else
  export NOT_HOST_ENV=''
fi

if [ -z "$NOT_HOST_ENV" ]; then

  if [[ $- != *i* ]]; then
    # non-interactive, do not start tmux or i3-gaps
    :
  elif [ -n "$TMUX_FAILURE" ]; then
    # if tmux failed the last time through, do not
    # try to start it again
    :
  elif [ "$(tty)" = /dev/tty1 ] && \
     [ "$(uname)" = Linux ]; then
    # startxfce4
    startx  # i3 based on ~/.xinitrc
    return
  elif [[ -z "$TMUX" ]] && [ -z "$BASH_SOURCE_IT" ]; then
    tmux_cmd=(~/Documents/scripts/tmux.sh -2 -u)  # -u -> utf-8; -2 -> force 256 colors
    default_session_to_attach_info="$(tmux ls -F '#S #{session_attached}' |\
      grep -vE '\s+1$' |\
      grep -E 'general|default|work|private|training' |\
      sort -r |\
      head -n1)"

    if [ -n "$default_session_to_attach_info" ]; then
      default_session_to_attach="$(echo "$default_session_to_attach_info" | awk '{ print $1 }')"
      default_session_num_of_attached_clients="$(echo "$default_session_to_attach_info" | awk '{ print $2 }')"
      if [ "$default_session_num_of_attached_clients" -lt 1 ]; then
        tmux_cmd+=('attach' '-t' "$default_session_to_attach")
      else
        tmux_cmd+=('new')
      fi
    else
      tmux_cmd+=('new')
    fi
    exec "${tmux_cmd[@]}"
    HISTFILE=''
    return  # do not source anything if outside tmux sessions
  fi
else
  HISTFILE=~/.not_host_env/.bash_history_x
  export USER=build-user
fi


export EDITOR=nvim
export VISUAL=nvim

# this breaks non-standard lesskey locations (`-k`)
#
# export LESSSECURE=1
# readonly LESSSECURE

export MANPAGER='less -R'

export BAT_STYLE=plain  # use change for + signs next to modifications --> git

export STARDICT_DATA_DIR="$HOME/.dictionaries/"

# TODO remove?
export GO111MODULE=off



source ~/Documents/scripts/source-me/common-functions.sh
for name in ~/Documents/scripts/source-me/completions_*; do
  source "$name"
done



# -----------------------
# extend PATH start
#

_add_to_PATH "$HOME/.bin"
_add_to_PATH "$HOME/go/bin"
_add_to_PATH "$HOME/.cargo/bin"
_add_to_PATH "$HOME/Documents/scripts/bin"
_add_to_PATH "$HOME/Documents/python/tools/bin"
_add_to_PATH "$HOME/Documents/scripts/private/bin"
_add_to_PATH "$HOME/Documents/dockerfiles/bin"
_add_to_PATH "$HOME/Documents/golang/tools/execute-in-repos"
_add_to_PATH "$HOME/Documents/golang/tools/execute-on-files"

#
# extend PATH end
# -----------------------

# --------------------------
# prompt style start
#

source ~/Documents/scripts/source-me/colors.sh
source ~/Documents/scripts/source-me/prompt.sh

#
# prompt style end
# --------------------------



# -------------------------
# common aliases START
#

# STARDICT START
alias def='sdcv --use-dict "quick_italian-english" --use-dict "dictd_www.mova.org_biology" --use-dict "American_Idioms 2nd Ed" --use-dict "Drug information" --use-dict "Pharmaceutical terms" --use-dict "Concise Oxford Thesaurus 2nd Ed. (Eng-Eng)" --use-dict "dictd_www.mova.org_1000pbio" --use-dict "dictd_www.mova.org_aviation" --use-dict "dictd_www.mova.org_idioms" --use-dict "dictd_www.mova.org_religion" --use-dict "English Dialects 3.0 (En-En)" --use-dict "Merriam-Webster'"'"'s Collegiate Thesaurus (En-En)" --use-dict "The BBI Combinatory Dictionary of English (En-En)" --use-dict "American Heritage Dictionary 4th Ed. (En-En)" --use-dict "Concise Oxford English Dictionary (En-En)" --use-dict "Macmillan English Dictionary (En-En)" --use-dict "Macmillan English Thesaurus (En-En)" --use-dict "The Chambers Thesaurus (En-En)"'

alias def-ger="sdcv --use-dict 'Duden'"

alias trans-ger-eng="sdcv --use-dict 'German-English' --use-dict 'quick_ding-ger-eng' --use-dict 'quick_frank-deu-eng' --use-dict 'quick_german-english'"

alias trans-eng-ger="sdcv --use-dict 'quick_ding-eng-ger' --use-dict 'quick_english-german' --use-dict 'quick_frank-eng-deu' --use-dict 'English - German' --use-dict 'English-German'"

alias trans-ita-ger="sdcv --use-dict 'Italian - German'"
alias trans-ger-ita="sdcv --use-dict 'German - Italian'"
alias trans-eng-ita="sdcv --use-dict 'quick_english-italian' --use-dict 'English - Italian'"
alias trans-ita-eng="sdcv --use-dict 'quick_italian-english'"
# STARDICT END

alias make='make --warn-undefined-variables'

alias ag="ag --color-line '0;32' --color-path '0;35' --color-match '1;31'"

alias objdump='objdump -M intel'
alias ropper='ropper --no-color'

alias cheat='~/Documents/scripts/cheat.sh ~/Documents/cheatsheets'
alias rezepte='~/Documents/scripts/cheat.sh ~/Documents/rezepte'

alias ls='ls --color=auto'

# TODO do not forget update `akgprg`
# in `.vimrc`
alias grep='grep \
              --exclude-dir=.git \
              --exclude-dir=.helm \
              --exclude-dir=.tox \
              --exclude-dir=.pulumi \
              --exclude-dir=.cache \
              --exclude-dir=.mypy_cache \
              --exclude-dir=.eggs \
              --exclude-dir=*.egg-info \
              --exclude-dir=*venv* \
              --exclude-dir=_build \
              --exclude-dir=__pycache__ \
              --exclude-dir=.pytest_cache \
              --exclude-dir=htmlcov \
              --exclude="*.html" \
              --exclude=build.*trace \
              --exclude=Session.vim \
              --color'

alias jq='jq --monochrome-output --raw-output'
alias yq='yq --monochrome-output --raw-output'

# shellcheck disable=SC2154
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR="$(cat $HOME/.rangerdir)"; cd "$LASTDIR"'

alias git_goto_toplevel='cd "$(git rev-parse --show-toplevel)"'

alias formats-youtube-dl='youtube-dl -F'

# use unknown filetype -> disable any filetype specific things
alias vimr="vim -c 'set ft=asdf'"
alias vimy="vimn -c ':set ft=yaml'"
alias vimj="vimn -c ':set ft=json'"



alias keepassxc-allow-screencapture='/Applications/KeePassXC.app/Contents/MacOS/KeePassXC --allow-screencapture >/dev/null 2>&1 &'


# common aliases END
# -------------------------


# ---------------------------
# common functions START
#

ed-callable () {
  # calling it:
  #
  # $ less /tmp/asdf.txt
  # asdf
  # asdfasfd
  # .venv/bin/asdf
  # aasdf/.venv/bin/asdf
  # aasdf/  .venv/bin/asdf
  # ~/
  # $ ed-callable 'g/.venv/d' /tmp/asdf.txt
  # 73
  # 14
  # ~/
  # $ less /tmp/asdf.txt
  # asdf
  # asdfasfd

  # $command could be 'g/.venv/d' ... this would delete any line containing `.venv`
  command="$1"
  shift

  ed "$@" < <(echo "$command"; echo w)
}

date-from-epoch () {
  date --iso-8601=seconds -d@"$(expr substr "$1" 1 10)"
}

hex-little-endian () {
  if [ -z "$1" ]; then
    vim -c ':%!xxd -e' -
  else
    vim -c ':%!xxd -e' "$1"
  fi
}


tmux-send-command-all-panes () {
  _tmux_send-keys_all_panes --hit-enter -- "$@"
}

tmux-swap-pane () { command tmux swap-pane -U; }

tmux-join-pane () {
  command tmux join-pane -t "$(tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2)" -s "$1"
}

tmux-save-pane-history () {
  if [ -z "$1" ]; then
    echo '[!] No file path provided!' >&2
    return
  fi

  last_arg="${*:$#}"
  # we might want to provide `-t %15` to save the history for pane %15
  set -- "${@:1:$(($#-1))}"

  # snatched from https://unix.stackexchange.com/questions/26548/write-all-tmux-scrollback-to-a-file/236845#236845
  tmux capture-pane "$@" -S - -p > "$last_arg"
}

tmux-set-pane-title () {
  tmux select-pane -T "$*"
}


n-for-dir-in-tmux-pane-below() {
  local dir="$1"
  tmux split-window -d -v
  tmux send-keys -t .+ "n $dir" C-m
  tmux selectp -t .+
}


ffmpeg-save-screenshot () {
  local TIMESTAMP=''
  local IMAGE_TYPE=''
  local NAME_SCREENSHOT=''

  local timestamp_opt='-t'
  local name_screenshot_opt='--name-screenshot'
  local image_type_jpg_opt='--jpg'
  local image_type_png_opt='--png'

  while [ $# -gt 0 ]; do
  key="$1"
    case "$key" in
      "$name_screenshot_opt")
      NAME_SCREENSHOT="$2"
      shift 2
      ;;

      "$timestamp_opt")
      TIMESTAMP="$2"
      shift 2
      ;;

      "$image_type_jpg_opt")
      IMAGE_TYPE=jpg
      shift
      ;;

      "$image_type_png_opt")
      IMAGE_TYPE=png
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

  echo "$@"
  if [ $# -lt 1 ]; then
    # shellcheck disable=SC2154
    echo -e "${YELLOW}[.] No file provided.$NC"
    return
  fi
  if [ -z "$IMAGE_TYPE" ]; then
    echo -e "[.] No image type supplied. Use ${YELLOW}"'`'"$image_type_jpg_opt"'`'"$NC or ${YELLOW}"'`'"$image_type_png_opt"'`'"$NC".
    return
  fi
  if [ -z "$NAME_SCREENSHOT" ]; then
    echo -e "[.] No name for screenshot. Use ${YELLOW}"'`'"$name_screenshot_opt"'`'"$NC."
    return
  fi
  if [ -z "$TIMESTAMP" ]; then
    echo -e "[.] No timestamp given. Use ${YELLOW}"'`'"$timestamp_opt"'`'"$NC."
    return
  fi

  ffmpeg -ss "$TIMESTAMP" -i "$1" -vframes 1 ~/Pictures/"$NAME_SCREENSHOT"."$IMAGE_TYPE"

}


mpv () {
  (command mpv "$@" 1>/dev/null 2>/dev/null &)
}


_report-videos () {
  ~/Documents/scripts/normal-privileges_systemd_scripts/report-videos.sh
}

video-sync () {
  local fetch=true

  while [ $# -gt 0 ]; do
  key="$1"
    case "$key" in
      --no-fetch)
      fetch=''
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

  if [ -n "$fetch" ]; then
    _report-videos
    echo
  fi

  ~/Documents/golang/tools/video-syncer/video-syncer "$@"

}

video-sync-mpv-watch-later-files () {
  set +x
  if [ "$1" != --no-fetch ]; then
    _report-videos
    echo
  fi
  ~/Documents/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files "$@"
}


download-and-drc-latest () {

  local link podcast_name timestamp

  _help () {
    echo >&2
    echo 'Make sure to not re-download any videos (podcast app might get confused &' >&2
    echo 'more CPU will be burned ...)' >&2
    echo "Link to check: $GREEN$link$NC" >&2
    echo >&2
    echo "\$3 should match this format $YELLOW$(date '+%Y%m%d')$NC" >&2
    echo  >&2
    echo "[.] ${GREEN}usage e.g.:$NC" >&2
    echo '   $ download-and-drc-latest "'"https://www.youtube.com/channel/UCFn4S3OexFT9YhxJ8GWdUYQ/videos"'" "'"oxide-and-friends"'" "'"5 weeks ago"'" ' >&2
    echo '   $ download-and-drc-latest "'"https://www.youtube.com/channel/UCFn4S3OexFT9YhxJ8GWdUYQ/videos"'" "'"oxide-and-friends"'" "'"2023-05-08"'" ' >&2
  }


  link="$1"
  podcast_name="$2"
  timestamp="$3"

  if ! ~/Documents/scripts/download-and-drc.sh --link "$link" --folder-name "$podcast_name" --date-stamp "$timestamp"; then
    _help
    return
  fi

}
download-and-drc-batch () {
  local batch_file podcast_name
  batch_file="$1"
  podcast_name="$2"

  _help () {
    echo >&2
    echo "[.] ${GREEN}usage e.g.:$NC" >&2
    echo '   $ download-and-drc-batch /tmp/batch "'"Rene Borbonus"'"' >&2
    echo '   $ download-and-drc-batch /tmp/batch "'"oxide-and-friends"'"' >&2
  }


  link="$1"
  podcast_name="$2"
  timestamp="$3"

  if ! ~/Documents/scripts/download-and-drc.sh --batch-file "$batch_file" --folder-name "$2"; then
    _help
  fi
}


get-yt-links-for-downloads () {
  find "$1" -mindepth 1 | sed -r 's|(.*)([A-z0-9-]{11})\.[A-z0-9]{2,6}|\2 #  \1|
                                  /^\s*$/d
                                  s#^#https://youtu.be/#'
}


_link-shared-password-store () {

    if [ -z "$PASSWORD_STORE_DIR" ]; then
      # shellcheck disable=SC2154
      echo -e "${RED}[!] unable to link files.$NC\n    PASSWORD_STORE_DIR variable empty!"
      exit 1
    fi


    # ensure all subdirectories exist to be able to link
    # files into them
    find ~/.password-store -path ~/.password-store/.git -prune -o -type d \
         -exec sh -c \ 'mkdir -p "$(echo "$0" | sed "s#.*password-store#$PASSWORD_STORE_DIR#")" ' {} \;


    find ~/.password-store -path ~/.password-store/.git -prune -o -regextype posix-egrep -regex '.*\.(bash|gpg)' \
         -exec sh -c 'ln -sf "$0" "$(echo "$0" | sed "s#.*password-store#$PASSWORD_STORE_DIR#")"' {} \;

}

weather () {
  curl -sL "https://v2.wttr.in/$*"
}

# snatched from https://github.com/jessfraz/dotfiles/blob/b6571ea19f86733933395127d0eec52b75206ef9/.aliases#L86
# View HTTP traffic
# shellcheck disable=SC2154
alias sniff="sudo ngrep -d \"\$_ngrep_interface\" -t '^(GET|POST) ' 'tcp and port 80'"
# shellcheck disable=SC2139
alias httpdump="sudo tcpdump -i \"\$_ngrep_interface\" -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""





doi_view () {
  #firefox --private-window "https://doi.org/$1"
  call_browser "https://doi.org/$1"
}


neomutt () {
  # default attachment download/upload location set to:
  (cd ~/Downloads/mutt && command neomutt "$@")
}


dl-youtube () {
  youtube-dl --add-metadata -f "$@"
}

dl-youtube-part-of-m4a () {
  local start="$1"
  local duration="$2"
  local url="$3"

  youtube-dl --add-metadata -f 140 --postprocessor-args "-ss $start -t $duration" "$url"
}

_dl-youtube-filter()
{
  local url

  url="$1"
  shift

  cmd=('youtube-dl' '-w' '--add-metadata' "$@" -- "$url")
  set -x
  "${cmd[@]}"
  set +x
}

dl-playlist () {
  first_arg="$1"
  shift

  youtube-dl --add-metadata -f "$first_arg" "$@" \
    -o '%(playlist_title)s/%(playlist_index)s %(title)s-%(id)s.%(ext)s'
}


ccat () {
  if ! pygmentize -g "$@" 2>/dev/null; then
    if [ $# -lt 2 ]; then
      set -- -
    fi
    cat -- "$@"
  fi
}
# shellcheck disable=SC2120
lessc () {
  ccat "$1" | less -R
}


pdf-extract-pages () {
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
     -dFirstPage="$3" -dLastPage="$4" \
     -sOutputFile="$2" "$1"
}

pdf-merge () {
  last_arg="${*:$#}"
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


audacious-push-playlists () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src=~/.config/audacious/playlists
  dst='fastmail:'"$username"'.fastmail.com/files/-configs/audacious/playlists'

  _rclone_verbose_sync_operation "$@" "$src" "$dst"
}


audacious-fetch-playlists () {
  local username
  local src
  local dst

  username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
  src='fastmail:'"$username"'.fastmail.com/files/-configs/audacious/playlists'
  dst=~/.config/audacious/playlists

  _rclone_verbose_sync_operation "$@" "$src" "$dst"

  if [ "$(uname)" = Darwin ]; then
    set -x
    sed -ri 's#/home/flo#/Users/florian.sorko#' "$dst"/*.audpl
    set +x
  else
    set -x
    sed -ri 's#/Users/florian.sorko#/home/flo#' "$dst"/*.audpl
    set +x
  fi

}


# nicked from https://leahneukirchen.org/dotfiles/bin/zombies
list-zombies-and-parents () {
  ps -eo state,pid,ppid,comm | awk '
    { cmds[$2] = $NF }
    /^Z/ { print $(NF-1) "/" $2 " zombie child of " cmds[$3] "/" $3 }'
  }


_pkg-update_completions-return () {

  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac
}


docker-rm-1st-ctr () {
  docker rm -f "$(docker ps | tail -n +2 | head -n1 | awk '{ print $1 }')"
}

docker-exec-1st-ctr () {
  docker exec -it "$(docker ps | tail -n +2 | head -n1 | awk '{ print $1 }')" "$@"
}

edit-bash-history () {
  # :$ to start at the end of the file
  vim -c ':$' "$HISTFILE"

  # snatched from https://superuser.com/a/1692033
  neovim_undo_dir="$(nvim -e +"redir>>/dev/stdout | echo &undodir | redir END" -scq | tail -n +2)"

  (sleep 300 && rm "$neovim_undo_dir"/*bash_history* 1>/dev/null 2>&1  &)
}


new-docker () {
  edit-docker "$@"
}
new-mutt () {
  edit-mutt "$@"
}



edit-dot-files () {
  pushd ~/Documents/dot-files
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
edit-zig () {
  _edit-wrapper --dir ~/Documents/zig/tools "$1"
}
edit-python () {
  _edit-wrapper --dir ~/Documents/python/tools "$1"
}
edit-script () {
  _edit-wrapper --dir ~/Documents/scripts "$1"
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


cheatsheets_pull () {
  (
  if cd ~/Documents/cheatsheets; then
    git pull origin master
  fi
  )
}

cheatsheets_commit_and_push () {
  (
  if cd ~/Documents/cheatsheets; then
    git add .
    git commit -m "$(date --iso-8601=minutes)"
    git push -u origin master
  fi
  )
}

rezepte_commit_and_push () {
  (
  if cd ~/Documents/rezepte; then
    git add .
    git commit -m "$(date --iso-8601=minutes)"
    git push -u origin master
  fi
  )
}

_checkout-wrapper () {
  local dir="$1"
  shift

  git -C "$dir" checkout -- "$@"
}

checkout-dot-files () {
  _checkout-wrapper ~/Documents/dot-files "$@"
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
checkout-zig () {
  _checkout-wrapper ~/Documents/zig/tools "$@"
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
  commit-in-dir ~/Documents/dot-files "$@"
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
commit-zig () {
  commit-in-dir ~/Documents/zig/tools "$@"
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

  git -C "$dir" diff "$@"
}

diff-dot-files () {
  _diff-wrapper ~/Documents/dot-files "$@"
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
diff-zig () {
  _diff-wrapper ~/Documents/zig/tools "$@"
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
diff-cheat () {
  _diff-wrapper ~/Documents/cheatsheets "$@"
}
diff-rezepte () {
  _diff-wrapper ~/Documents/rezepte "$@"
}

_log-wrapper () {
  local dir="$1"
  set -- "${@:2:$(($#))}"; # drop first arg

  args=(l)
  if [ -n "$GIT_PAGER" ]; then
    args=(log)
  fi

  git -C "$dir" "${args[@]}" "$@"
}

log-dot-files () {
  _log-wrapper ~/Documents/dot-files "$@"
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
log-zig () {
  _log-wrapper ~/Documents/zig/tools "$@"
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
log-cheat () {
  _log-wrapper ~/Documents/cheatsheets "$@"
}
log-rezepte () {
  _log-wrapper ~/Documents/rezepte "$@"
}

_reset_wrapper () {
  dir="$1"
  shift

  if [ "$1" = --hard ]; then
    git -C "$dir" clean -df
  fi
  git -C "$dir" reset "$@"
}

reset-dot-files () {
  _reset_wrapper ~/Documents/dot-files "$@"
  (cd ~/Documents/dot-files && make)
}
reset-docker () {
  _reset_wrapper ~/Documents/dockerfiles "$@"
}
reset-mutt () {
  _reset_wrapper ~/.mutt "$@"
}
reset-go () {
  _reset_wrapper ~/Documents/golang/tools "$@"
}
reset-zig () {
  _reset_wrapper ~/Documents/zig/tools "$@"
}
reset-python () {
  _reset_wrapper ~/Documents/python/tools "$@"
}
reset-script () {
  _reset_wrapper ~/Documents/scripts "$@"
}
reset-vim () {
  _reset_wrapper ~/.vim "$@"
}
reset-cheat () {
  _reset_wrapper ~/Documents/cheatsheets "$@"
}
reset-rezepte () {
  _reset_wrapper ~/Documents/rezepte "$@"
}

_status-wrapper () {
  local dir="$1"
  shift

  git -C "$dir" status -sb "$@"
}

status-dot-files () {
  _status-wrapper ~/Documents/dot-files "$@"
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
status-zig () {
  _status-wrapper ~/Documents/zig/tools "$@"
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
status-cheat () {
  _status-wrapper ~/Documents/cheatsheets "$@"
}
status-rezepte () {
  _status-wrapper ~/Documents/rezepte "$@"
}


_sync-os-configs () {
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
}

work-sync () {
 set -x
  _sync-os-configs

  echo

  ~/Documents/golang/tools/execute-in-repos/execute-in-repos git pull origin master

  echo
  set -x
  work_recompile_go_tools_conditionally
  echo

  set -x
  video-sync

  set -x
  video-sync-mpv-watch-later-files  --no-fetch
  echo
}

work_recompile_go_tools_conditionally () {
  set +x

  # re-compile go tools if binaries are older than go files
  while read -r line; do
    if [[ "$line" =~ .git ]]; then
      # skip git directory
      continue
    fi

    (
      if cd "$line"; then
        binary="$(basename "$line")"
        binary_date="$(date -r "$binary" '+%s'  2>/dev/null || echo -n '1')"
        if [ "$(date -r main.go '+%s')" -gt "$binary_date" ]; then
          echo "[.] recompiling '$binary'"
          make no_debug
        fi
      fi
    )
  done < <(find ~/Documents/golang/tools/ -maxdepth 1 -mindepth 1 -type d)
}

work_push () {
  ~/Documents/golang/tools/execute-in-repos git push
}

work_fetch () {
  ~/Documents/golang/tools/execute-in-repos git fetch
}

work-checked-in () {
  ~/Documents/scripts/checked-in.sh repo.conf
}


git-enable-delta () {
  export GIT_PAGER='delta --syntax-theme "Monokai Extended Light" '
}
git-disable-delta () {
  unset GIT_PAGER
}

#
# git helpers END
# ---------------------------
