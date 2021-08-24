#!/usr/bin/env bash
# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial

set +u

_watch-namespace_completions()
{
  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  _complete-namespaces() {
      if [ -z "$_all_namespaces" ]; then
        read -r -d '' -a _all_namespaces < <(oc get project -o json | jq '.items[].metadata.name' | sed 's#^"##;s#"$##')
      export _all_namespaces
      fi

    # _all_namespaces=('test-something-blub' 'test-something-minus')

    COMPREPLY=($(compgen -W "$(_print "${_all_namespaces[@]}")" -- "$cur_word"))
  }

  COMPREPLY=()
  local cur_word prev_word

  cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"

  case "${prev_word}" in
    -n)
      _complete-namespaces
      ;;
    -r)
      _complete_kubektx
      ;;
    *)
      COMPREPLY=($(compgen -W "$(echo -e '-h\n-n\n-r')" -- "$cur_word"))
      ;;
  esac

}

complete -F _watch-namespace_completions 'watch-namespace'

