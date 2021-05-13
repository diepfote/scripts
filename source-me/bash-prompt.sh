#!/usr/bin/env bash

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $GREEN\w$NC ]\n$ "

BASH_HELPER_FILENAME="bash-helper"

if [ "$(hostname)" = docker-desktop ]; then
  BASH_HELPER_FILENAME="bash-helper-linux"
fi

_ps1 () {
  PS1="$(~/Documents/golang/tools/bash-helper/"$BASH_HELPER_FILENAME")"
}

# General comments on PROMPT_COMMAND
#
# 1) run refresh_tmux_kubecontext in subshell to supress job output
# 2) sed ... is used to delete trailing whitespace presumably introduced
#    by fzf ctrl-r completion
#
unset PROMPT_COMMAND
export PROMPT_COMMAND="_ps1; source ~/.sh_functions; history -a; history -n"

######## leave these ↓ here - might modify PROMPT_COMMAND

eval "$(direnv hook bash 2>/dev/null || true)"

eval "$(gh completion -s bash 2>/dev/null || true)"

