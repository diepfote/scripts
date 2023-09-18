#!/usr/bin/env bash


source ~/Documents/scripts/source-me/common-functions.sh

alias kctx="kubectx"
alias kx="kubectx"
alias ktx="kubectx"
alias velero_annotate_all_volumes_for_pod='~/Documents/scripts/kubernetes/velero_annotate_all_volumes_for_pod.sh'
alias krew='kubectl krew'
_add_to_PATH "$HOME/.krew/bin"

alias kn=kubens


_print () {
  for name in "$@"; do
    echo "$name"
  done
}

_set_namespaces () {
  read -r -d '' -a _all_namespaces < <(kubectl get namespace -o json | jq '.items[].metadata.name' | sed 's#^"##;s#"$##')
  export _all_namespaces
}

_complete-namespaces() {
  local cur_word="$1"

  if [ -z "$_all_namespaces" ]; then
    _set_namespaces
  fi

# _all_namespaces=('test-something-blub' 'test-something-minus')

  read -r -d '' -a _tmp_general < <(compgen -W "$(_print "${_all_namespaces[@]}")" -- "$cur_word")
  export COMPREPLY=("${_tmp_general[@]}")
  unset _tmp_general
}

_set-kubecontext_complete ()
{
  local cur_word="$1"
  export DIR_TO_COMPLETE="$HOME/.kube"
  _complete_files_and_dirs
}

_autocomplete_cluster_suffix () {
  local cur_word="$1"
  read -r -d '' -a _tmp_general < <(compgen -W "$(ls ~/.kube/generated | sed 's#.*-##' | sort | uniq)" -- "$cur_word")
  export COMPREPLY=("${_tmp_general[@]}")
  unset _tmp_general
}

oc-get-pod () {
  local partial_pod_name="$1"
  local do_not_match="$2"
  oc-get-pods "$partial_pod_name" "$do_not_match" | head -n 1
}
oc-get-pods () {
  local partial_pod_name="$1"
  local do_not_match="$2"
  # shellcheck disable=SC2154
  if [ -n "$namespace" ]; then
    if [ -n "$do_not_match" ]; then
      kubectl get pod -o name -n "$namespace" | grep -vE "$do_not_match"  | grep "$partial_pod_name"
    else
      kubectl get pod -o name -n "$namespace"  | grep "$partial_pod_name"
    fi
  else
    if [ -n "$do_not_match" ]; then
      kubectl get pod -o name | grep -vE "$do_not_match"  | grep "$partial_pod_name"
    else
      kubectl get pod -o name | grep "$partial_pod_name"
    fi
  fi
}

oc-get-pod-openshift () {
  local do_not_match="build|deploy"
  oc-get-pods-openshift "$partial_pod_name" "$do_not_match" | head -n 1
}
oc-get-pods-openshift () {
  local do_not_match="build|deploy"
  oc-get-pods "$1" "$do_not_match"
}


oc-get-pod-volumes () {
  local separator="$1"

  [[ -z "$pod" ]] && pod="$2"

  if [ -n "$namespace" ]; then
    kubectl get "$pod" -n "$namespace" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  else
    kubectl get "$pod" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  fi
}


oc-get-node-ip () { oc get node "$1" -o jsonpath="{.status.addresses[0].address}" ; }

oc-get-users-for-scc () {
  oc get scc "$1" -o jsonpath='{.users}' | sed 's#\[##;s#\]##' | tr ' ' '\n';
}


ocj () {
 cat - | oc neat -o json | vimj -c FormatJSON
}
ocy () {
 cat - | oc neat | vimy
}


# shellcheck disable=SC2119
unset-kubecontext () { set-kubecontext; }

# shellcheck disable=SC2120
set-kubecontext () {
  unset _all_namespaces  # reset custom namespace array for completions

  if [ -z "$1" ]; then
    unset KUBECONFIG
    return
  fi

  export KUBECONFIG=~/.kube/"$1"
}

# shellcheck disable=SC2119
unset-openstack-cloud () { set-openstack-cloud; }

# shellcheck disable=SC2120
set-openstack-cloud () {
  if [ -z "$1" ]; then
    unset OS_CLOUD
    return
  fi

  export OS_CLOUD="$1"
}

