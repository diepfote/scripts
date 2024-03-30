#!/usr/bin/env bash

lf () {
  local f dir

  command lf "$@"

  f=/tmp/.lf-cwd

  if [ -f "$f" ]; then
      read -r dir < "$f"
      # shellcheck disable=SC2164
      cd "$dir"
      rm "$f"
  fi

  n_empty-trash
}

alias n=lf
