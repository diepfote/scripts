# Structure nicked from:
# https://devmanual.gentoo.org/tasks-reference/completion/index.html
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial


_pkgbuild_completions()
{
  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  COMPREPLY=()
  local cur_word="${COMP_WORDS["$COMP_CWORD"]}"
  local prev_word="${COMP_WORDS["$COMP_CWORD"-1]}"

  read -r -d '' -a _foreign_pkgs < <(pacman -Qmq)
  export _foreign_pkgs


    COMPREPLY=($(compgen -W "$(_print '-c' '-v' "${_foreign_pkgs[@]}")" -- "$cur_word"))

}

complete -F _pkgbuild_completions pkgbuild

