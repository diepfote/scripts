if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  export RED="$(tput setaf 1)"
  export GREEN="$(tput setaf 2)"
  export YELLOW="$(tput setaf 3)"
  export BLUE="$(tput setaf 4)"
  export PURPLE="$(tput setaf 5)"
  export BOLD="$(tput bold)"
  export NC="$(tput sgr0)"  # no color
fi

# colorize man pages with 'bat'
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

