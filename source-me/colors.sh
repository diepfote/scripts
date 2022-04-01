set +u
if [[ $- != *i* ]] && [ -z "$SET_COLORS_ALWAYS" ]; then
  return
fi

if which tput >/dev/null 2>&1; then
  ncolors="$(tput colors || true)"
fi

if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  export RED="$(tput setaf 1)"
  export GREEN="$(tput setaf 2)"
  export YELLOW="$(tput setaf 3)"
  export BLUE="$(tput setaf 4)"
  export PURPLE="$(tput setaf 5)"
  export BOLD="$(tput bold)"
  export NC="$(tput sgr0)"  # no color
  unset ncolors
fi

