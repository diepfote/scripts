#!/usr/bin/env bash
#
# original taken from https://github.com/chkhd/bash-prompt
#


is_git_prompt_useful_here () {
	git rev-parse HEAD &> /dev/null || return 1

	return 0
}

parse_git_branch () {
	git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_ahead_behind () {
	local curr_branch
	local curr_remote
	local curr_merge_branch
	local count
	local ahead
	local behind
	local ab

	curr_branch=$(git rev-parse --abbrev-ref HEAD)
	curr_remote=$(git config branch."$curr_branch".remote)

	# If the branch is local only, it won't have a remote
	test $? -gt 0 && return 1

	curr_merge_branch=$(git config branch."$curr_branch".merge | sed 's#refs/heads/###' )
	count=$(git rev-list --left-right --count "${curr_branch}...${curr_remote}/${curr_merge_branch}" 2> /dev/null)

	# Might be the first commit, which is not pushed yet
	test $? -gt 0 && return 1

	ahead=$(printf "$count" | cut -f1)
	behind=$(printf "$count" | cut -f2)

	ab=''
	test "$ahead" -gt 0 && ab+="↑${ahead}"

	if test "$behind" -gt 0; then
		test -n "$ab" && ab+=" ↓${behind}" || ab+="↓${behind}"
	fi

	test -n "$ab" && printf "$ab" || printf ''
}

parse_git_last_fetch () {
	local f
	local now
	local last_fetch
	local opts

	opts=$([[ $(uname -s) == "Darwin" ]] && printf -- '-f%%m' || printf -- '-c%%Y')
	f=$(git rev-parse --show-toplevel)
	now=$(date +%s)
	last_fetch=$(stat "$opts" "${f}/.git/FETCH_HEAD" 2> /dev/null || printf '')

	test -n "$last_fetch" && test $(( now > (last_fetch + 15*60) )) -eq 1 && printf '☇' || printf ''
}

parse_git_status () {
	local bits
	local dirty
	local deleted
	local untracked
	local newfile
	local ahead
	local renamed

	git status --porcelain | (
		unset dirty deleted untracked newfile ahead renamed
		while read -r line ; do
			case "$line" in
				'M'*)	dirty='m' ;;
				'UU'*)	dirty="✖$dirty" ;;
				'D'*)	deleted='d' ;;
				'??'*)	untracked='…' ;;
				'A'*)	newfile='n' ;;
				'C'*)	ahead='↑' ;;
				'R'*)	renamed='r' ;;
			esac
		done

		bits="$dirty$deleted$untracked$newfile$ahead$renamed"
		test -n "$bits" && printf "$bits" || printf ''
	)
}

gen_git_status () {
	local ahead_behind
	local fetch
	local status

	ahead_behind=$(parse_git_ahead_behind)
	fetch=$(parse_git_last_fetch)
	status=$(parse_git_status)

	test -n "$ahead_behind" && test -n "$status" && status+=" ${ahead_behind}" || status+="${ahead_behind}"
	test -n "$fetch" && test -n "$status" && status+=" ${fetch}" || status+="${fetch}"

	printf "$status"
}

gen_ps1 () {
	# This needs to be the first command otherwise it will not have correct exit code
	local ec="$?"

	local grey
	local prompt
	local branch
	local status
	local div
	local mdiv
	local ediv
	local git_prompt
	local venv
	local top
	local bottom

	PS1=''
	grey='\[\e[38;5;242m\]'

	# Indicate if previous command succeeded or not
	prompt='$ '
	div="${grey}|${NC} "
	mdiv='⎨ '
	ediv=' ⎬'
	test ${ec} -eq 0 && prompt="${prompt}" || prompt="${RED}${prompt}"

	# If inside git managed directory show git information
	git_prompt=''
	branch=''
	status=''

	if is_git_prompt_useful_here; then
		branch=$(parse_git_branch)
		status=$(gen_git_status)


		git_prompt="${branch}"
		test -n "$status" && git_prompt+=" ${BLUE}${status}${NC}"
		git_prompt="${div}${PURPLE}${git_prompt}${NC}"
	fi

	# If venv is active show it
  if [ -n "$VIRTUAL_ENV" ]; then
    venv=""$(echo "${VIRTUAL_ENV}" | sed "s#"$PWD"/##")"${CONDA_PREFIX}"
    venv=$(test -n "$venv" && printf "$div$YELLOW$venv$NC" || printf '')
  fi

	bottom="${prompt}${NC}"
	PS1="$mdiv$GREEN\\w $NC$git_prompt$venv$ediv\\n$bottom"
  # echo %HIS2$PS1
}

unset PS1
# !! remember to escape dollar signs, otherwise PS1 caches the output !!
# export PS1="[ $LIGHT_GREEN\w$NC ]\n$ "

# run refresh_tmux_kubecontext in subshell to supress job output
unset PROMPT_COMMAND
export PROMPT_COMMAND="gen_ps1; (refresh_tmux_openstack_and_kubecontext); source ~/.sh_functions; history -a; history -n"

######## leave these ↓ here - might modify PROMPT_COMMAND

[[ -x kubectl ]] && source <(kubectl completion bash)

eval "$(direnv hook bash 2>/dev/null || true)"

eval "$(gh completion -s bash 2>/dev/null || true)"

