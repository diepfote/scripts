export EDITOR=nvim
export VISUAL=nvim

export FZF_DEFAULT_COMMAND="find ~"
export FZF_DEFAULT_OPTS="--height '40%' --layout=reverse --border"

# kube-fzf (AUR pkg)
alias logspod=/usr/bin/findpod
alias getpod=/usr/bin/tailpod
alias port-forward_pod=/usr/bin/pfpod


source ~/Documents/scripts/source-me_colors.sh
source ~/Documents/scripts/source-me_prompt-style.sh


# source fish functions
sh_functions_file=~/.sh_functions 
[[ ! -f "$sh_functions_file" ]] && ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"


# source bashacks
bashacks_repo_source=https://github.com/merces/bashacks
bashacks_dir=~/Documents/infosec_pkgs/bashacks
bashacks_source_file="$bashacks_dir"/bashacks.sh
if [[ -f "$bashacks_source_file" ]]; then
  source "$bashacks_source_file"
else
  echo -e "${PURPLE}[>] missing bashacks. Downloading from $bashacks_repo_source\n$NC"
  git clone --depth=1 "$bashacks_repo_source" "$bashacks_dir" 
  
  pushd "$bashacks_dir"
  make
  popd

  source "$bashacks_source_file"
fi



# pipenv aliases
alias pipsh="pipenv shell"



# kubernetes aliases
alias kb=kubectl
alias kbg="kubectl get"
alias kc=kubectl
alias kcg="kubectl get"
alias kn="kubens"
alias kbD="kubectl delete"
alias kba="kubectl apply"
alias kctx="kubectx"
alias kx="kubectx"
alias ktx="kubectx"



# PATH
export PATH="$PATH":$HOME/.krew/bin



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
    -e ssh_private_key_filename=bb_work_openstack \
    -v ~/.ssh:/tmp/.ssh.host \
    -v ~/.vpass:/tmp/.vpass \
    -v ~/.jenkins-api-tokens.vpass:/tmp/jenkins-api-tokens.vpass:ro \
    -v ~/.jenkins-api-tokens.yml:/tmp/jenkins-api-tokens.yml:ro \
    -v ~/openrc.sh:/tmp/openrc.sh \
    -w /work \
    "${ANSIBLE_DEV_ENV_IMG}"
}
