#!/usr/bin/env bash


tmux_id ()
{
    tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2
}

_set_kubernetes_vars ()
{
  export KUBECONFIG="$(cat ~/._kubeconfig 2>/dev/null)"
  context="$(kubectl config current-context 2>/dev/null)"
  namespace="$(kubectl config get-contexts 2>/dev/null | grep \* | tr -s ' ' | cut -d ' ' -f5)"
}

show_kubernetes_context ()
{
  if [ -n "$context" ]; then
    echo -n "($context)  "
  fi
}

show_kubernetes_namespace ()
{
  if [ -n "$namespace" ]; then
    echo -n ">$namespace< "
  fi
}
display_kubernetes_info()
{
  _set_kubernetes_vars
  echo -en "$(show_kubernetes_context)$(show_kubernetes_namespace)"
}


display_tmux_info()
{
  echo -en "[ $(tmux_id) | $(display_kubernetes_info)] "
}


display_tmux_info

