export EDITOR=nvim
export VISUAL=nvim

export LESSSECURE=1
readonly LESSSECURE

export NNN_COLORS=2136  # use a different color for each context -> version >= 3.2
export NNN_TRASH=1
export NNN_BMS="d:~/Documents;h:~;D:~/Downloads;f:~/.config/fish/functions;s:~/Documents/scripts;L:~/Library/LaunchAgents;l:~/Documents/systemd-user;S:~/.config/systemd/user;E:/etc/;v:~/Videos;V:/run/media/$USER/large_drive/Media/Video-Files/Videos;m:~/Movies"  # jump locations for nnn
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;v:imgview;t:imgthumb'  # curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR="$(cat $HOME/.rangerdir)"; cd "$LASTDIR"'

export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"


export PATH="$HOME/.krew/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# -------------------------
# DARWIN
if [ "$(uname)" = 'Darwin' ]; then

  __w_pkg_update () {
    local _old_virtual_env="$VIRTUAL_ENV"

    if [ -n "$VIRTUAL_ENV" ]; then
      deactivate || pushd ~ && local is_direnv_directory=true
    fi

    source ~/Documents/scripts/source-me/progressbar.sh
    progressbar

    echo -e '\n--------\npip\n'
    for pkg in $(pip3 list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1); do
      pip3 install --user "$pkg"  | grep -v 'already satisfied'
    done

    echo -e '\n--------\nnpm\n'
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do
      # safe upgrade all https://gist.github.com/othiym23/4ac31155da23962afd0e
      npm -g install "$package"
    done


    echo -e '\n--------\nkrew\n'
    kubectl krew update
    kubectl krew upgrade  2>&1 |  grep -vE 'already on the newest version|Upgrading plugin'

    echo -e '\n--------\napm\n'
    apm upgrade -c false

    echo -e '\n--------\nbrew\n'
    echo -en "  $PURPLE"; echo -e "[>] pulling updates...$NC"
    brew update

    echo -en "  $PURPLE"; echo -e "[>] starting upgrades...$NC"
    brew upgrade


    kill %%
    if [ -n "$_old_virtual_env" ]; then
      if [ -n "$is_direnv_directory" ]; then
        popd
      else
        source "$_old_virtual_env/bin/activate"
      fi
    fi
  }
  alias w-pkg-update=__w_pkg_update

  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

  # python 3.9 = default
  export PATH="/usr/local/opt/python@3.9/libexec/bin:$PATH"
  export PATH="$HOME/Library/Python/3.9/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/python@3.9/lib:$LDFLAGS"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.9/lib/pkgconfig:$PKG_CONFIG_PATH"

  # pyenv version 3.6
  export PATH="$PATH:$HOME/.pyenv/versions/3.6.12/bin"


  export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8

  alias tss_pass='pass ***REMOVED***D***/***REMOVED*** -c'
  alias tss_user='pass ***REMOVED***D***/***REMOVED*** | tail -n 1 | pbcopy'
  alias doc_internal_keepass_pass='pass ***REMOVED***D***/***REMOVED***passwords/***REMOVED*** -c'
  alias bb_***REMOVED***_pass='pass ***REMOVED***D*** -c'

  alias kn=kubens

  export PASSWORD_STORE_DIR=~/.password-store-work
else
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

alias git_goto_toplevel='cd "$(git rev-parse --show-toplevel)"'
alias test-sed=~/Documents/scripts/test-sed.sh

type nvim 1>/dev/null 2>/dev/null  && alias vim=nvim

# pipenv aliases
alias pipsh="pipenv shell"

# openstack aliases
alias openstack='HTTPS_PROXY="socks5://localhost:5555" openstack'
alias terraform='HTTPS_PROXY="socks5://localhost:5555" terraform'

# for the ***REMOVED*** ***REMOVED***_openshift repo
alias tox='[ -f "$KUBECONFIG" ] && cp "$KUBECONFIG" ~/.kube/config; tox'

# -------------------------


# -------------------------
# files to source
source ~/Documents/scripts/source-me/colors.sh
source ~/Documents/scripts/source-me/prompt-style.sh
source ~/Documents/scripts/tmux_info.sh 1>/dev/null 2>/dev/null


# source fish functions
sh_functions_file=~/.sh_functions
[[ ! -f "$sh_functions_file" ]] && \
  ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"

# -------------------------

