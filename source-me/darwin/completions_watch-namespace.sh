# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial


_watch-namespace_completions()
{
  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  local prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"
  local suggestions

  case "${prev_word}" in
    -n)
    if [ -z "$_all_namespaces" ]; then
      read -r -d '' -a _all_namespaces < <(oc get project -o json | jq '.items[].metadata.name' | sed 's#^"##;s#"$##')
      export _all_namespaces

      # _all_namespaces=('test-something-blub' 'test-something-minus')
fi

      COMPREPLY=($(compgen -W "$(_print "${_all_namespaces[@]}")" -- "$cur_word"))
      ;;
    -r)
      COMPREPLY=($(compgen -W "$(echo -e '9\n10\n12')" -- "$cur_word"))
      ;;
    *)
      COMPREPLY=($(compgen -W "$(echo -e '-h\n-n\n-r')" -- "$cur_word"))
      ;;
  esac

}

complete -F _watch-namespace_completions 'watch-namespace'

