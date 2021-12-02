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
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

  export PATH="/usr/local/opt/python@3.8/bin:$PATH"
  export PATH="$HOME/Library/Python/3.8/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/python@3.8/lib"

  export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8
fi
# -------------------------

# -------------------------
# common aliases
alias ls='ls --color=auto'

alias grep='grep --exclude-dir=.git \
                 --exclude-dir=.tox \
                 --exclude-dir=.venv \
                 --color'

type nvim 1>/dev/null 2>/dev/null  && alias vim=nvim

# pipenv aliases
alias pipsh="pipenv shell"

# kubernetes aliases
alias kb=kubectl
alias kbg="kubectl get"
alias kc=kubectl
alias kcg="kubectl get"
alias kn="kubens"
alias kbD="kubectl delete"
alias kba="kubectl apply"
alias kctx="kubectx"
alias kx="kubectx"
alias ktx="kubectx"
alias velero_annotate_all_volumes_for_pod='~/Documents/scripts/kubernetes/velero_annotate_all_volumes_for_pod.sh "$@"'
alias krew='kubectl krew'

# openstack aliases
alias openstack='HTTPS_PROXY="socks5://localhost:5555" openstack'

# for the ***REMOVED*** ***REMOVED***_openshift repo
alias tox='cp "$KUBECONFIG" ~/.kube/config; tox'

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

