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


_add_to_PATH "$HOME/go/bin"


# -------------------------
# DARWIN
if [ "$(uname)" = 'Darwin' ]; then

  alias w-pkg-update=~/Documents/scripts/w-pkg-update.sh

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

  alias offlineimap=~/Documents/scripts/bin/darwin/offlineimap.sh

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

# -------------------------

# -------------------------
# common aliases
alias ls='ls --color=auto'

alias grep='grep --exclude-dir=.git \
                 --exclude-dir=.tox \
                 --exclude-dir=.venv \
                 --color'

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR="$(cat $HOME/.rangerdir)"; cd "$LASTDIR"'

alias git_goto_toplevel='cd "$(git rev-parse --show-toplevel)"'
alias test-sed=~/Documents/scripts/test-sed.sh

type nvim 1>/dev/null 2>/dev/null  && alias vim=nvim
alias vimy="vim -c ':set ft=yaml'"
alias vimj="vim -c ':set ft=json'"

alias view_dirs=~/Documents/scripts/view_dirs.sh

mpv () {
  command mpv "$1" 1>/dev/null 2>/dev/null &
}


# pipenv aliases
alias pipsh="pipenv shell"


# -------------------------


# -------------------------
# files to source
source ~/Documents/scripts/source-me/colors.sh

# source fish functions
sh_functions_file=~/.sh_functions
[[ ! -f "$sh_functions_file" ]] && \
  ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"

# -------------------------

