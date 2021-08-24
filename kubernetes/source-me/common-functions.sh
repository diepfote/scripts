#!/usr/bin/env bash

# shellcheck disable=SC1090
source ~/Documents/scripts/source-me/common-functions.sh

alias kctx="kubectx"
alias kx="kubectx"
alias ktx="kubectx"
alias velero_annotate_all_volumes_for_pod='~/Documents/scripts/kubernetes/velero_annotate_all_volumes_for_pod.sh'
alias krew='kubectl krew'
_add_to_PATH "$HOME/.krew/bin"

alias kn=kubens


# show completion for kubeconfigs
_complete_kubektx () {
  _complete_context_files () {
    local FILE_EXCHANGE_DIR="$1"
    # TODO improve robustness
    IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
  }

  local FILE_EXCHANGE_DIR=~/.kube
  _complete_context_files "$FILE_EXCHANGE_DIR"
}


# shellcheck disable=SC1090
***REMOVED*** () {
  local ***REMOVED***
  ***REMOVED***="$(oc get pod -n ***REMOVED***-ci -o name | grep '***REMOVED***-***REMOVED***-' | sed 's#^pod/##' | tail -n1)"

  ***REMOVED*** () {
    set -x
    oc exec -it "$1"  -n ***REMOVED***-ci -- cp ***REMOVED***/***REMOVED***/id_rsa /tmp/
    oc exec -it "$1"  -n ***REMOVED***-ci -- chmod 600 /tmp/id_rsa
    oc exec -it "$1"  -n ***REMOVED***-ci -- ssh -o 'StrictHostKeyChecking=no' -t -i /tmp/id_rsa ***REMOVED***"$2"
  }

  ***REMOVED*** "$***REMOVED***" "$1" || set +x
  set +x
}


operator-exec-pod () {
  ~/Documents/***REMOVED***/***REMOVED***.sh -p "$(pass ***REMOVED***D***/***REMOVED*** | head -n1)" "$(pass tail ***REMOVED***D***/***REMOVED*** | head -n1)"
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


set-kubecontext () {
  export KUBECONFIG=~/.kube/"$1"
}

set-openstack-cloud () {
  export OS_CLOUD="$1"
}

