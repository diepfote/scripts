#!/usr/bin/env bash
# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial

set +u

_all-of-a-service_completions()
{

  COMPREPLY=()
  local cur_word prev_word

  cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"

  case "${prev_word}" in
    -n|--namespace-regex)
      _complete-namespaces "$cur_word"
      ;;
    -C|--cluster-suffix)
      _autocomplete_cluster_suffix "$cur_word"
      ;;
    --env)
      _tmp_general=()
      _tmp_general+=(prod)
      _tmp_general+=(int)
      _tmp_general+=(test)
      read -r -d '' -a _tmp_array < <(compgen -W "$(_print "${_tmp_general[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_array[@]}")
      unset _tmp_general _tmp_array

      ;;
    *)
      read -r -d '' -a _tmp_general < <(compgen -W "$(echo -e '-h\n-n\n--namespace-regex\n-C\n--cluster-suffix\n--env')" -- "$cur_word")
      export COMPREPLY=("${_tmp_general[@]}")
      unset _tmp_general
      ;;
  esac

}

