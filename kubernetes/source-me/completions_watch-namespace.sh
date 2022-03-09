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
        read -r -d '' -a _all_namespaces < <(kubectl get namespace -o json | jq '.items[].metadata.name' | sed 's#^"##;s#"$##')
      export _all_namespaces
      fi

    # _all_namespaces=('test-something-blub' 'test-something-minus')

      read -r -d '' -a _tmp_general < <(compgen -W "$(_print "${_all_namespaces[@]}")" -- "$cur_word")
      export COMPREPLY=("${_tmp_general[@]}")
      unset _tmp_general
  }

  COMPREPLY=()
  local cur_word prev_word prev_prev_word first_word plugin_name
  plugin_name=watch-namespace
  cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"
  prev_prev_word="${COMP_WORDS["$COMP_CWORD"-2]}"
  first_word="${COMP_WORDS[0]}"

  if [ "${prev_word}" =  "$plugin_name" ]; then
      read -r -d '' -a _tmp_general < <(compgen -W "$(echo -e '-h\n-n\n-r')" -- "$cur_word")
      export COMPREPLY=("${_tmp_general[@]}")
      unset _tmp_general

      return
  elif [ "${prev_prev_word}" =  "$plugin_name" ]; then
    case "${prev_word}" in
      -n)
        _complete-namespaces
        ;;
      -r)
        _set-kubecontext_complete "$cur_word"
        ;;
      *)
        ;;
    esac

    return
  fi

  executable="$first_word"
  if [ "$executable" = oc ]; then
    # execute base func from /usr/local/etc/bash_completion.d/oc
    __start_oc
  elif [ "$executable" = kubectl ]; then
    # execute base func from /usr/local/etc/bash_completion.d/kubectl
    __start_kubectl
  fi


}

complete -o default -o nospace -F _watch-namespace_completions oc
complete -o default -o nospace -F _watch-namespace_completions kubectl

