# enable __git_ps1 command
source /usr/share/git/completion/git-prompt.sh  # installed with git

# settings for __git_ps1
export GIT_PS1_SHOWDIRTYSTATE=1        # + for staged, * if unstaged.
export GIT_PS1_SHOWUNTRACKEDFILES=1    # % if there are untracked files.
export GIT_PS1_SHOWUPSTREAM='verbose'  # 'u='=no difference, 'u+1'=ahead by 1 commit 


# automatically add all config files as a colon delimited string in KUBECONFIG
unset KUBECONFIG
for file in ~/.kube/* ; do
  if [ "$(basename $file)" = "kubectx" ]; then
    echo 1>/dev/null
  elif [ -f $file ]; then
    export KUBECONFIG=$KUBECONFIG:$file
  fi
done



show_openstack_project()
{
  local output="$(env | grep OS_PROJECT_NAME | cut -d = -f2)"
  echo -n "*$output*"
}


