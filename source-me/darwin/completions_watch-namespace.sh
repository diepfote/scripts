# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial



_complete_namespaces () {
  if [ -z "$all_namespaces" ]; then
    read -r -d '' -a all_namespaces < <(oc get project -o json | jq '.items[].metadata.name' | sed 's#^"##;s#"$##')
    # all_namespaces=('test-something-blub' 'test-something-minus')
  fi

  _print_namespaces () {
    for name in "${all_namespaces[@]}"; do
      echo "$name"
    done
  }
  _print_namespaces
}

_watch-namespace_completions()
{
  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  local prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"
  local suggestions

  case "${prev_word}" in
    -n)
      COMPREPLY=($(compgen -W "$(_complete_namespaces)" -- "$cur_word"))
      ;;
    -r)
      COMPREPLY=($(compgen -W "9 10 12" -- "$cur_word"))
      ;;
    *)
      COMPREPLY=($(compgen -W "-n -r" -- "$cur_word"))
      ;;
  esac

}

complete -F _watch-namespace_completions 'watch-namespace'

