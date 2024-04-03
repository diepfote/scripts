#!/usr/bin/env bash
# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial

set +u

_trace_completions()
{

  COMPREPLY=()
  local cur_word prev_word

  cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"

  case "${prev_word}" in
    -n|--namespace)
      _complete-namespaces "$cur_word"
      ;;
    attach)
      _tmp_general=()
      _tmp_general+=(-n)
      _tmp_general+=(--namespace)
      _tmp_general+=(-h)
      _tmp_general+=(--help)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array
      ;;
    delete)
      _tmp_general=()
      _tmp_general+=(-n)
      _tmp_general+=(--namespace)
      _tmp_general+=(-A)
      _tmp_general+=(--all-namespaces)
      _tmp_general+=(-h)
      _tmp_general+=(--help)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array
      ;;
    logs|log)
      _tmp_general=()
      _tmp_general+=(-n)
      _tmp_general+=(--namespace)
      _tmp_general+=(-f)
      _tmp_general+=(--follow)
      _tmp_general+=(-h)
      _tmp_general+=(--help)
      _tmp_general+=(--timestamps)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array
      ;;
    run)
      _tmp_general=()
      _tmp_general+=(-n)
      _tmp_general+=(--namespace)
      _tmp_general+=(-a)
      _tmp_general+=(--attach)
      _tmp_general+=(-c)
      _tmp_general+=(--container)
      _tmp_general+=(-f)
      _tmp_general+=(--filename)
      _tmp_general+=(--imagename)
      _tmp_general+=(-h)
      _tmp_general+=(--help)
      _tmp_general+=(--timestamps)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array
      ;;
    *)
      _tmp_general=()
      _tmp_general+=(help)
      _tmp_general+=(attach)
      _tmp_general+=(delete)
      _tmp_general+=(get)
      _tmp_general+=(logs)
      _tmp_general+=(run)
      _tmp_general+=(version)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array
      ;;
  esac

}

