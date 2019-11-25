if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  PURPLE="$(tput setaf 5)"
  BOLD="$(tput bold)"
  NC="$(tput sgr0)"  # no color
fi

# colorize man pages with 'bat'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

