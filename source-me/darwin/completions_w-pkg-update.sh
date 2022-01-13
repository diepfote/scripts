_w-pkg-update_completions()
{
  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"


  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W "$(echo -e '-g\n-r\n--disable-remote-login\n-h')" -- "$cur_word"))
      ;;
  esac

}

complete -F _w-pkg-update_completions 'w-pkg-update'

