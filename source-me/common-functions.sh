#!/usr/bin/env bash
# shellcheck disable=SC1090

pip-chill () {
  head -n1 "$(which pip-chill)"
  command pip-chill "$@"
}

find-sorted () {
  # e.g. call with exlusions in current dir
  # $ find-sorted . -path "*/.git" -prune -o -path "*/.tox" -prune -o -path '*/tests' -prune -o -path '*/*venv' -prune -o -path '*/*eggs' -prune -o -path '*/*cache*' -prune -o


  dir="$1"
  shift

  # shellcheck disable=SC2016
  find "$dir" -mindepth 1 "$@" -printf "%T@\t%p\n" 2>&1 \
    | sort -n -r \
    | stdbuf -o0 awk -F '\t' '{ print $2 }'
}


_print () {
  for name in "$@"; do
    printf -- "$name\n"
  done
}


_add_to_MANPATH () {
  local path_to_add="$1"

 if [ -z "$path_to_add" ]; then
   return
 fi

 # shellcheck disable=2076
 # we want literal matching in this case
 #
 if [[ ! "$MANPATH" =~ "$path_to_add" ]]; then
   # new path not yet present
   export MANPATH="$path_to_add:$MANPATH"
 fi
}


_display-PATH () {
  if [ -n "$1" ]; then
    echo ---
    echo "$1"
  fi

  set -x
  echo "$PATH" | tr ':' '\n'
  set +x
}

reload () {
  set -x
  _remove_from_PATH homebrew
  set -x
  _remove_from_PATH "$USER"

  # stupid workaround for $SHELL set to whatever you did with `chsh -s`
  # on Mac OS
  if [ -n "$ZSH" ]; then
    # snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L145
    # Reload the shell (i.e. invoke as a login shell)
    set -x
    exec /bin/zsh
  else
    # snatched from https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.aliases#L145
    # Reload the shell (i.e. invoke as a login shell)
    set -x
    exec "${SHELL}"
  fi
}

_remove_from_PATH () {
  set +x
  local temp_path_list='' first=true debug=''

  if [ "$2" = debug ]; then
    debug=true
  fi

  if [ -n "$debug" ]; then
    _display-PATH "before removal of '$1'"
  fi

  while read -r path; do
    if [[ "$path" =~ $1 ]]; then
      continue
    fi

    if [ -n "$first" ]; then
      first=''
      temp_path_list="$path"
    else
      temp_path_list="$temp_path_list:$path"
    fi

  done < <(echo "$PATH" | sed -r 's#:#\n#g')

  export PATH="$temp_path_list"
  if [ -n "$debug" ]; then
    _display-PATH "after removal of '$1'"
  fi
}

_add_to_PATH () {
  local path_to_add reverse_order
  reverse_order=''
  path_to_add="$1"

  if [ -z "$path_to_add" ]; then
    return
  fi

  if [ $# -gt 1 ]; then
    reverse_order=true
  fi


 # shellcheck disable=2076
 # we want literal matching in this case
 #
 if [[ ! "$PATH" =~ "$path_to_add" ]]; then
   # new path not yet present

   if [ -z "$reverse_order" ]; then
     export PATH="$path_to_add:$PATH"
   else
     export PATH="$PATH:$path_to_add"
   fi
 fi
}

# shellcheck disable=SC2120
yesno ()
{
	[[ -t 0 ]] || return 0
	local response
	read -r -p "$1 [y/N] " response
	[[ "$response" == [yY] ]] && \
    return 0 || \
    return 1
}

yesno_safe ()
{
	[[ -t 0 ]] || return 0
	local response
	read -r -p "$1 [y/N] " response
	[[ "$response" == [yY] ]] || die "Received no answer for yesno!"
}

die ()
{
	echo "$@" >&2
	exit 1
}

findlast () {
  # taken from https://stackoverflow.com/questions/4561895/how-to-recursively-find-the-latest-modified-file-in-a-directory/63107922#63107922

  if [ $# -lt 2 ]; then
    rsync -rL --list-only "$1" | grep -v '^d' | sort -k3,4r | head -n 5
  elif [ "$1" = -1 ]; then
    rsync -rL --list-only "$2" | grep -v '^d' | sort -k3,4r
  else
    rsync -rL --list-only "$2" | grep -v '^d' | sort -k3,4r | head -n "$1"
  fi
}

get_random_alphanumeric ()
{
  tr -dc _A-Z-a-z-0-9 < /dev/urandom| head -c "$1"
}



_get_cmd_tmux_pane_id () {
# BSD 2-Clause License

# Copyright (c) 2020, Florian Begusch
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
  # list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
  # this list of conditions and the following disclaimer in the documentation
  # and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  cmd_to_search_for="$1"

  local pane_to_reload
  if [ "$(uname)" = Darwin ]; then
    set -x
    # get parent process id for some command
    pane_to_reload="$(ps -f | grep "$cmd_to_search_for" | grep -v grep | tr -s ' ' | cut -d ' ' -f4)"
    set +x
  else
   pane_to_reload="$(for pane_pid in $(tmux list-panes -F '#{pane_pid}'); do \
    ps -f --ppid "$pane_pid" \
    | awk '{ print substr($0, index($0,$8))}' \
    | grep "/$cmd_to_search_for" 1>/dev/null && itis=true; \
      set +u; [ "$itis" = true ] \
      && echo "$pane_pid"; itis=false; set -u ; done)"
  fi

   # in case there is no match
   # ensure the subsequent pane is chosen
   #
   if [ -n "$pane_to_reload" ]; then
    pane_ids=$(tmux list-panes -F "#{pane_pid} #{pane_id}" \
     | grep "$pane_to_reload" | cut -d ' ' -f2)
   fi
   [ -z "$pane_ids" ] && pane_ids='.+'

   echo "$pane_ids" | tr ' ' '\n' | tail -n 1
}






#############################
# copied pass functions start

_complete_files_and_dirs_helper () {
  DO_NOT_ADD_SLASH_AFTER_DIR=${DO_NOT_ADD_SLASH_AFTER_DIR:-}


  # completion file for bash

  # Copyright (C) 2012 - 2014 Jason A. Donenfeld <Jason@zx2c4.com> and
  # Brian Mattern <rephorm@rephorm.com>. All Rights Reserved.
  # This file is licensed under the GPLv2+. Please see COPYING for more information.
	prefix="${DIR_TO_COMPLETE:-$HOME/Repos/scripts}"
	prefix="${prefix%/}/"
	suffix=".gpg"
	autoexpand=${1:-0}

	local IFS=$'\n'
	local items=($(compgen -f $prefix$cur))

	# Remember the value of the first item, to see if it is a directory. If
	# it is a directory, then don't add a space to the completion
	local firstitem=""
	# Use counter, can't use ${#items[@]} as we skip hidden directories
	local i=0

	for item in ${items[@]}; do
		# if there is a unique match, and it is a directory with one entry
		# autocomplete the subentry as well (recursively)
		if [[ ${#items[@]} -eq 1 && $autoexpand -eq 1 ]]; then
			while [[ -d $item ]]; do
				local subitems=($(compgen -f "$item/"))
				local filtereditems=( )
				for item2 in "${subitems[@]}"; do
					[[ $item2 =~ /\.[^/]*$ ]] && continue
					filtereditems+=( "$item2" )
				done
				if [[ ${#filtereditems[@]} -eq 1 ]]; then
					item="${filtereditems[0]}"
				else
					break
				fi
			done
		fi

		# append / to directories
		[[ -d $item && -z "$DO_NOT_ADD_SLASH_AFTER_DIR" ]] && item="$item/"

		item="${item%$suffix}"
		COMPREPLY+=("${item#$prefix}")
		if [[ $i -eq 0 ]]; then
			firstitem=$item
		fi
		let i+=1
	done

	# The only time we want to add a space to the end is if there is only
	# one match, and it is not a directory
	if [[ $i -gt 1 || ( $i -eq 1 && -d $firstitem ) ]]; then
		compopt -o nospace
	fi
}

_complete_files_and_dirs()
{
  # completion file for bash

  # Copyright (C) 2012 - 2014 Jason A. Donenfeld <Jason@zx2c4.com> and
  # Brian Mattern <rephorm@rephorm.com>. All Rights Reserved.
  # This file is licensed under the GPLv2+. Please see COPYING for more information.
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
  # content deleted
  # .
  # .
		COMPREPLY+=($(compgen -W "${commands}" -- ${cur}))
		_complete_files_and_dirs_helper 1
}

# copied pass functions end
###########################

