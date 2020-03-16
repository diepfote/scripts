# enable __git_ps1 command
git_prompt=/usr/share/git/completion/git-prompt.sh  # installed with git
[[ -f "$git_prompt" ]] || \
  git_prompt=/usr/local/etc/bash_completion.d/git-prompt.sh
source "$git_prompt"

# settings for __git_ps1
export GIT_PS1_SHOWDIRTYSTATE=1        # + for staged, * if unstaged.
export GIT_PS1_SHOWUNTRACKEDFILES=1    # % if there are untracked files.
export GIT_PS1_SHOWUPSTREAM='verbose'  # 'u='=no difference, 'u+1'=ahead by 1 commit



show_openstack_project()
{
  local project="$(env | grep OS_PROJECT_NAME | cut -d = -f2)"
  local user="$(env | grep OS_USERNAME | cut -d = -f2)"

  if [ "$project" != "" ]; then
    echo -en " *OS_PROJECT=$NC$project$YELLOW* *OS_USERNAME=$NC$user$YELLOW*  "
  fi
}

