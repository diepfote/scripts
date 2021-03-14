#!/usr/bin/env bash

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $GREEN\w$NC ]\n$ "

_ps1 () {
  PS1="$(~/Documents/golang/tools/bash-helper/bash-helper)"
}

_rm_trailing_whitespace_bashhist () {
  # set -x
  sed -ir 's#\s*$##' ~/.bash_history
  # set +x
}

refresh_tmux_openstack_and_kubecontext () {
  echo "$OS_CLOUD" > /tmp/._openstack_cloud
  echo "$KUBECONFIG" > /tmp/._kubeconfig
  tmux refresh-client &
}


# General comments on PROMPT_COMMAND
#
# 1) run refresh_tmux_kubecontext in subshell to supress job output
# 2) sed ... is used to delete trailing whitespace presumably introduced
#    by fzf ctrl-r completion
#
unset PROMPT_COMMAND
export PROMPT_COMMAND="_ps1; source ~/.sh_functions; history -a; _rm_trailing_whitespace_bashhist; history -n"

if [ "$(uname)" = Darwin ]; then
  export PROMPT_COMMAND="(refresh_tmux_openstack_and_kubecontext); $PROMPT_COMMAND"
fi

######## leave these ↓ here - might modify PROMPT_COMMAND

[[ -x kubectl ]] && source <(kubectl completion bash)

eval "$(direnv hook bash 2>/dev/null || true)"

eval "$(gh completion -s bash 2>/dev/null || true)"

