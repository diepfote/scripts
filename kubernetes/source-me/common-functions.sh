#!/usr/bin/env bash

if [ "$(uname)" = Darwin ]; then
  alias kctx="kubectx"
  alias kx="kubectx"
  alias ktx="kubectx"
  alias velero_annotate_all_volumes_for_pod='~/Documents/scripts/kubernetes/velero_annotate_all_volumes_for_pod.sh'
  alias krew='kubectl krew'
  _add_to_PATH "$HOME/.krew/bin"

  alias kn=kubens
  # for the ***REMOVED*** ***REMOVED***_openshift repo
  alias tox='[ -f "$KUBECONFIG" ] && cp "$KUBECONFIG" ~/.kube/config; tox'

  oc-get-pod () {
    local partial_pod_name="$1"
    local do_not_match="$2"
    oc-get-pods "$partial_pod_name" "$do_not_match" | head -n 1
  }
  oc-get-pods () {
    local partial_pod_name="$1"
    local do_not_match="$2"
    set -x
    # shellcheck disable=SC2154
    if [ -n "$namespace" ]; then
      kubectl get pod -o name -n "$namespace" | grep -vE "$do_not_match"  | grep "$partial_pod_name"
    else
      kubectl get pod -o name | grep -vE "$do_not_match"  | grep "$partial_pod_name"
    fi
    set +x
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

  set_kubecontext () {
    export KUBECONFIG=~/.kube/"$1"
  }


  _watch-namespace-wrapper () {
    tmux split-window -d  'export BASH_SOURCE_IT=true; bash'
    sleep 10
    tmux send-keys -t .+ "source ~/.bashrc; set_kubecontext \"$1\"; watch oc get pod -n $2" C-m
 }

  watch-9-namespace () {
    _watch-namespace-wrapper prod-9-os-muc "$1"
  }
  watch-10-namespace () {
    _watch-namespace-wrapper 10-prod-os-muc "$1"
  }
  watch-12-namespace () {
    _watch-namespace-wrapper 12-prod-os-muc "$1"
  }


  refresh_tmux_openstack_and_kubecontext () {
    echo "$OS_CLOUD" > /tmp/._openstack_cloud
    echo "$KUBECONFIG" > /tmp/._kubeconfig
    tmux refresh-client &
  }


fi

