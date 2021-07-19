_w-pkg-update_completions()
{
  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  local prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"
  local suggestions


  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W "-g -r -h" -- "$cur_word"))
      ;;
  esac

}

complete -F _w-pkg-update_completions 'w-pkg-update'

