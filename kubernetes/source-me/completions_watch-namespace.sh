#!/usr/bin/env bash
# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial


source ~/Repos/scripts/kubernetes/source-me/common-functions.sh

set +u



_watch-namespace_completions()
{

  COMPREPLY=()
  local cur_word prev_word

  cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"

  case "${prev_word}" in
    -n)
      _complete-namespaces "$cur_word"
      ;;
    -r)
      _set-kubecontext_complete "$cur_word"
      ;;
    *)
      read -r -d '' -a _tmp_general < <(compgen -W "$(echo -e '-h\n-n\n-r')" -- "$cur_word")
      export COMPREPLY=("${_tmp_general[@]}")
      unset _tmp_general
      ;;
  esac

}

complete -F _watch-namespace_completions 'watch-namespace'

