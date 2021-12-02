#!/usr/bin/env bash


yesno()
{
	[[ -t 0 ]] || return 0
	local response
	read -r -p "$1 [y/N] " response
	[[ $response == [yY] ]] || die "Received no answer for yesno!"
}

die()
{
	echo "$@" >&2
	exit 1
}


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

set_openstack_context()
{
  source ~/.openstack/"$1"
}

set_kubecontext()
{
  export KUBECONFIG=~/.kube/"$1"
}

refresh_tmux_kubecontext()
{
  echo "$KUBECONFIG" > ~/._kubeconfig
  tmux refresh-client &
}


# docker config for ANSIBLE
export ANSIBLE_DEV_ENV_IMG="$(~/Documents/scripts/read_toml_setting.sh ~/Documents/config/work.conf ANSIBLE_DEV_ENV_IMG  2>/dev/null)"
ansible_dev_env ()
{
  docker run --rm -ti \
    --cap-drop=ALL \
    --hostname "ansible-dev" \
    --entrypoint=/bin/bash \
    "$@" \
     -v `pwd`:/work \
     -v ~/.m2/settings.xml:/root/.m2/settings.xml \
    -v ~/.ssh:/tmp/.ssh.host \
    -v ~/.vpass:/tmp/.vpass \
    -v ~/.jenkins-api-tokens.vpass:/tmp/jenkins-api-tokens.vpass:ro \
    -v ~/.jenkins-api-tokens.yml:/tmp/jenkins-api-tokens.yml:ro \
    -v ~/openrc.sh:/tmp/openrc.sh \
    -w /work \
    "${ANSIBLE_DEV_ENV_IMG}"
}

