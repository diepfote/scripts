export EDITOR=nvim
export VISUAL=nvim

export FZF_DEFAULT_COMMAND="find ~"
export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"

# kube-fzf (AUR pkg)
alias logspod=/usr/bin/tailpod
alias getpod=/usr/bin/findpod
alias port-forward_pod=/usr/bin/pfpod

# common aliases
ls='ls --color=auto'
[ "$(uname)" = 'Darwin' ] && alias grep='ggrep --exclude-dir=.git --color' \
  || alias grep='grep --exclude-dir=.git --color'
[ "$(uname)" = 'Darwin' ] && export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 \
  LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8
[ "$(uname)" = 'Darwin' ] && alias pip=pip3

source ~/Documents/scripts/source-me_colors.sh
source ~/Documents/scripts/source-me_prompt-style.sh
source ~/Documents/scripts/tmux_info.sh 1>/dev/null 2>/dev/null
for name in $(find ~/Documents/scripts -name 'source-me_completions*'); do
  source "$name"
done


# source fish functions
sh_functions_file=~/.sh_functions
[[ ! -f "$sh_functions_file" ]] && \
  ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"


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

set_kubecontext()
{
  export KUBECONFIG=~/.kube/"$1"
}

refresh_tmux_kubecontext()
{
  echo "$KUBECONFIG" > ~/._kubeconfig
  tmux refresh-client &
}

# -------------------------
# PATH
export PATH="$PATH":$HOME/.krew/bin

# add gnu utils to PATH
[ "$(uname)" = 'Darwin' ] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" && PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
# -------------------------



# docker config for ANSIBLE
export ANSIBLE_DEV_ENV_IMG="$(~/Documents/scripts/read_toml_setting.sh ~/Documents/config/work.conf ANSIBLE_DEV_ENV_IMG  2>/dev/null)"
ansible_dev_env ()
{
  docker run --rm -ti \
    --cap-drop=ALL \
    --hostname "ansible-dev" \
    --entrypoint=/bin/bash \
    "$@" \
     -v `pwd`:/work \
     -v ~/.m2/settings.xml:/root/.m2/settings.xml \
    -v ~/.ssh:/tmp/.ssh.host \
    -v ~/.vpass:/tmp/.vpass \
    -v ~/.jenkins-api-tokens.vpass:/tmp/jenkins-api-tokens.vpass:ro \
    -v ~/.jenkins-api-tokens.yml:/tmp/jenkins-api-tokens.yml:ro \
    -v ~/openrc.sh:/tmp/openrc.sh \
    -w /work \
    "${ANSIBLE_DEV_ENV_IMG}"
}

