#!/usr/bin/env bash

[[ $- != *i* ]] && return

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $GREEN\w$NC ]\n$ "

BASH_HELPER_FILENAME="bash-helper"

if [ -n "$IN_CONTAINER" ]; then
  BASH_HELPER_FILENAME="bash-helper-linux"
fi


if [ -n "$ZSH" ]; then
  PS1="$(~/Documents/golang/tools/bash-helper/"$BASH_HELPER_FILENAME")"
  export PS1

  eval "$(direnv hook zsh 2>/dev/null || true)"
  eval "$(gh completion -s zsh 2>/dev/null || true)"
else
  _ps1 () {
    PS1="$(~/Documents/golang/tools/bash-helper/"$BASH_HELPER_FILENAME")"
  }

  unset PROMPT_COMMAND
  export PROMPT_COMMAND="_ps1; history -a; history -n"

  ######## leave these ↓ here - will modify PROMPT_COMMAND
  #
  eval "$(direnv hook bash 2>/dev/null || true)"
  eval "$(gh completion -s bash 2>/dev/null || true)"
fi
