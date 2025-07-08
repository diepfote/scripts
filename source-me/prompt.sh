#!/usr/bin/env bash

[[ $- != *i* ]] && return
if [ -n "$TMUX_FAILURE" ]; then
  # abort `tmux refresh-client`
  # AND do not modify `PROMPT_COMMAND` or `PS1`
  return
fi

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $GREEN\w$NC ]\n$ "

BASH_HELPER_FILENAME="release/bash_helper"

if [ -n "$NOT_HOST_ENV" ]; then
  BASH_HELPER_FILENAME="x86_64-unknown-linux-gnu/${BASH_HELPER_FILENAME}"
fi


_ps1 () {
  if [[ "$PWD" =~ .*/deploy-[a-z-] ]]; then
    if [ -n "$PS1_TAGGED" ]; then
      :
    else
      :
    fi
    PS1_TAGGED=true
  fi
  PS1="$(~/Documents/rust/tools/bash_helper/target/"$BASH_HELPER_FILENAME")"
}

if [ -n "$ZSH" ]; then
  precmd () {
    _ps1
  }

  eval "$(direnv hook zsh 2>/dev/null || true)"
  eval "$(gh completion -s zsh 2>/dev/null || true)"
else
  # Assume BASH

  # looks like if we do not set this a 33k file expands to 433k!
  #
  shopt -s histappend

  unset PROMPT_COMMAND
  export PROMPT_COMMAND="_ps1; history -a; history -n"

  ######## leave these ↓ here - will modify PROMPT_COMMAND
  #
  eval "$(direnv hook bash 2>/dev/null || true)"
  eval "$(gh completion -s bash 2>/dev/null || true)"
fi
