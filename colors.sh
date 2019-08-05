#!/usr/bin/env bash

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

PURPLE='\033[1;35m'
ORANGE='\033[0;33m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color


echo -e "I ${ORANGE}love${NC} Stack Overflow"
echo -e "I ${PURPLE}love${NC} Stack Overflow"
echo -e "I ${CYAN}love${NC} Stack Overflow"
echo -e "I ${GREEN}love${NC} Stack Overflow"
echo

printf "I ${RED}love${NC} Stack Overflow\n"

echo -e "I ${RED}love${NC} Stack Overflow"

echo -e "I \033[1;31mlove\033[0m Stack Overflow"


# ------
# alternative taken from https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
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
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    BOLD=""
    NORMAL=""
  fi
# -----
