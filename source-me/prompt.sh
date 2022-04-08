#!/usr/bin/env bash

[[ $- != *i* ]] && return

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $GREEN\w$NC ]\n$ "

BASH_HELPER_FILENAME="bash-helper"

if [ -n "$IN_CONTAINER" ]; then
  BASH_HELPER_FILENAME="bash-helper-linux"
fi


_ps1 () {
  PS1="$(~/Documents/golang/tools/bash-helper/"$BASH_HELPER_FILENAME")"
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

  ######## leave these ↓ here - will modify PROMPT_COMMAND
  #
  eval "$(direnv hook bash 2>/dev/null || true)"
  unset PROMPT_COMMAND
  # clear _direnv_hook function call from PROMPT_COMMAND
  export PROMPT_COMMAND="_custom_direnv_hook; _ps1; history -a; history -n"

  _custom_direnv_hook () {
    if [[ "$(basename "$PWD")" =~ deploy-* ]]; then
      if [ "$DIRENV_PREVIOUS_LOCATION" = "$PWD" ]; then
        return
      fi
      export DIRENV_PREVIOUS_LOCATION="$PWD"

      echo 'Do you want to run direnv?'
      if yesno; then
        direnv reload
      fi
    else
      export DIRENV_PREVIOUS_LOCATION=''
    fi

  }


  eval "$(gh completion -s bash 2>/dev/null || true)"
  ########
fi
