#!/usr/bin/env bash


alias work_repo_template=~/Documents/scripts/work_repo_template.sh
alias w-git-delete-gone-branches=~/Documents/scripts/w-git-delete-gone-branches.sh
alias w-git-update=~/Documents/scripts/w-git-update.sh

alias git_execute_on_all_repos=~/Documents/scripts/git_execute_on_all_repos.sh
w-git_execute_on_all_repos () {
  git_execute_on_all_repos "$1" ~/Documents/config/work-repo.conf
}


yesno ()
{
	[[ -t 0 ]] || return 0
	local response
	read -r -p "$1 [y/N] " response
	[[ $response == [yY] ]] || die "Received no answer for yesno!"
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

alias sort-unique-keep-line-order-and-overwrite=~/Documents/scripts/sort_unique_keep_line_order_and_overwrite.sh


get_random_alphanumeric ()
{
  cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c "$1"
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

  if [ "$(uname)" = Darwin ]; then
    set -x
    # get parent process id for some command
    local pane_to_reload="$(ps -f | grep "$cmd_to_search_for" | grep -v grep | tr -s ' ' | cut -d ' ' -f4)"
    set +x
  else
   local pane_to_reload="$(for pane_pid in $(tmux list-panes -F '#{pane_pid}'); do \
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
  # completion file for bash

  # Copyright (C) 2012 - 2014 Jason A. Donenfeld <Jason@zx2c4.com> and
  # Brian Mattern <rephorm@rephorm.com>. All Rights Reserved.
  # This file is licensed under the GPLv2+. Please see COPYING for more information.
	prefix="${DIR_TO_COMPLETE:-$HOME/Documents/scripts}"
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
		[[ $item =~ /\.[^/]*$ ]] && continue

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
		[[ -d $item ]] && item="$item/"

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
	#local commands="init ls find grep show insert generate edit rm mv cp git help version ${PASSWORD_STORE_EXTENSION_COMMANDS[*]}"
	#if [[ $COMP_CWORD -gt 1 ]]; then
		#local lastarg="${COMP_WORDS[$COMP_CWORD-1]}"
		#case "${COMP_WORDS[1]}" in
			#init)
				#if [[ $lastarg == "-p" || $lastarg == "--path" ]]; then
					#_pass_complete_folders
					#compopt -o nospace
				#else
					#COMPREPLY+=($(compgen -W "-p --path" -- ${cur}))
					#_pass_complete_keys
				#fi
				#;;
			#ls|list|edit)
				#_complete_files_and_dirs_helper
				#;;
			#show|-*)
				#COMPREPLY+=($(compgen -W "-c --clip" -- ${cur}))
				#_complete_files_and_dirs_helper 1
				#;;
			#insert)
				#COMPREPLY+=($(compgen -W "-e --echo -m --multiline -f --force" -- ${cur}))
				#_complete_files_and_dirs_helper
				#;;
			#generate)
				#COMPREPLY+=($(compgen -W "-n --no-symbols -c --clip -f --force -i --in-place" -- ${cur}))
				#_complete_files_and_dirs_helper
				#;;
			#cp|copy|mv|rename)
				#COMPREPLY+=($(compgen -W "-f --force" -- ${cur}))
				#_complete_files_and_dirs_helper
				#;;
			#rm|remove|delete)
				#COMPREPLY+=($(compgen -W "-r --recursive -f --force" -- ${cur}))
				#_complete_files_and_dirs_helper
				#;;
			#git)
				#COMPREPLY+=($(compgen -W "init push pull config log reflog rebase" -- ${cur}))
				#;;
		#esac

		## To add completion for an extension command define a function like this:
		## __password_store_extension_complete_<COMMAND>() {
		##     COMPREPLY+=($(compgen -W "-o --option" -- ${cur}))
		##     _complete_files_and_dirs_helper 1
		## }
		##
		## and add the command to the $PASSWORD_STORE_EXTENSION_COMMANDS array
		#if [[ " ${PASSWORD_STORE_EXTENSION_COMMANDS[*]} " == *" ${COMP_WORDS[1]} "* ]] && type "__password_store_extension_complete_${COMP_WORDS[1]}" &> /dev/null; then
			#"__password_store_extension_complete_${COMP_WORDS[1]}"
		#fi
	#else
		COMPREPLY+=($(compgen -W "${commands}" -- ${cur}))
		_complete_files_and_dirs_helper 1
	#fi
}

# copied pass functions end
###########################


# kubernetes & openstack start
################

set_openstack_context()
{
  set -a
  source ~/.openstack/"$1"
  set +a
}

set_kubecontext ()
{
  export KUBECONFIG=~/.kube/"$1"
}

refresh_tmux_openstack_and_kubecontext () {
  echo "$OS_CLOUD" > ~/._openstack_cloud
  echo "$KUBECONFIG" > ~/._kubeconfig
  tmux refresh-client &
}

# kubernetes end
################

