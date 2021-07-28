_openstack_cloud_completions()
{
  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"

  if [ -z "$_clouds" ]; then
    read -r -d '' -a _clouds < <(grep -E '^  muc' ~/.config/openstack/clouds.yaml | sed -r 's#:##;s#\s*##g')
    export _clouds
  fi

  COMPREPLY=($(compgen -W "$(_print "${_clouds[@]}")" -- "$cur_word"))

}

complete -F _openstack_cloud_completions 'set-openstack-cloud'

