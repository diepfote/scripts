#!/usr/bin/env bash

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
export PS1="[ $GREEN\w$NC ]\n$ "

# run refresh_tmux_kubecontext in subshell to supress job output
unset PROMPT_COMMAND
# export PROMPT_COMMAND="gen_ps1; (refresh_tmux_openstack_and_kubecontext); source ~/.sh_functions; history -a; history -n"
export PROMPT_COMMAND="(refresh_tmux_openstack_and_kubecontext); source ~/.sh_functions; history -a; history -n"

######## leave these ↓ here - might modify PROMPT_COMMAND

[[ -x kubectl ]] && source <(kubectl completion bash)

eval "$(direnv hook bash 2>/dev/null || true)"

eval "$(gh completion -s bash 2>/dev/null || true)"

