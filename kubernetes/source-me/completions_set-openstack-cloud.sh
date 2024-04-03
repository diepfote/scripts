_openstack_cloud_completions()
{

  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"

  if [ -z "$_clouds" ]; then
    read -r -d '' -a _clouds < <(grep -E '^  [A-Za-z0-9]+' clouds.yaml | sed -r 's#:##;s#\s*##g' | grep -v expiration)
    export _clouds
  fi

  COMPREPLY=($(compgen -W "$(_print "${_clouds[@]}")" -- "$cur_word"))

}

complete -F _openstack_cloud_completions 'set-openstack-cloud'

