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
  local cloud="$(env | grep OS_CLOUD | cut -d = -f2)"
  local auth_url="$(env | grep OS_AUTH_URL | cut -d = -f2)"
  local project="$(env | grep OS_PROJECT_NAME | cut -d = -f2 )"
  local tenant="$(env | grep OS_TENANT_NAME | cut -d = -f2)"
  local auth_url="$(env | grep OS_AUTH_URL | cut -d = -f2)"
  local user="$(env | grep OS_USERNAME | cut -d = -f2 | tr '[:upper:]' '[:lower:]')"

  if [ -n "$project" ]; then
    echo -en "$YELLOW OS_P$NC:$project"
  fi
  if [ -n "$tenant" ]; then
    echo -en "$YELLOW OS_T$NC:$tenant"
  fi

  if [ -n "$auth_url" ] && [ -n "$user" ]; then
    echo -en "$YELLOW OS_U$NC:$user$YELLOW OS_URL$NC:$auth_url"
  fi

  if [ -n "$cloud" ]; then
    echo -en "$YELLOW OS_C$NC:$cloud"
  fi
}

