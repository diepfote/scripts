#!/usr/bin/env bash

source ~/Documents/scripts/source-me_prompt-style.sh

tmux_id ()
{
    tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2
}

set_kubernetes_vars ()
{
  export KUBECONFIG="$(cat ~/._kubeconfig 2>/dev/null)"
  context="$(kubectl config current-context 2>/dev/null)"
  namespace="$(kubectl config get-contexts 2>/dev/null | grep \* | tr -s ' ' | cut -d ' ' -f5)"

  minikube_running="$(ps -ef | grep -v grep | grep minikube)"
  minikube_configured="$(kubectl config current-context 2>/dev/null | grep minikube)"
}

show_kubernetes_context ()
{
  set_kubernetes_vars


  if [ -n "$context" ]; then
    local output="($context)  "
  fi

  if [ -z "$minikube_configured" ]; then
    echo -n "$output"
  else
    if [ ! -z "$minikube_running" ]; then
      echo -n "$output"
    fi
  fi

}

show_kubernetes_namespace ()
{
  set_kubernetes_vars

  if [ -n "$namespace" ]; then
    local output=">$namespace< "
  fi

  if [ -z "$minikube_configured" ]; then
    echo -n "$output"
  else
    if [ ! -z "$minikube_running" ]; then
      echo -n "$output"
    fi
  fi
}

parse_git_branch()
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

custom_git_ps1()
{
  :
  #__git_ps1 | tr '(' '[' | tr ')' ']'
}

display_kubernetes_info()
{
  echo -en " $(custom_git_ps1) $(show_kubernetes_context)$(show_kubernetes_namespace)"
}


get_audio_muted()
{
  if [ "$(uname)" = Darwin ]; then
    echo -en "muted: $(osascript -e 'output muted of (get volume settings)')"
  else
    echo -en "muted:$(pactl list sinks | grep Mute | head -n 1 | cut -d ':' -f2)"
  fi
}

display_tmux_info()
{
  echo -en "$(get_audio_muted) | [ $(tmux_id) |  $(display_kubernetes_info)] "
}

display_tmux_info

#echo -en $(show_kubernetes_context)$YELLOW$(show_kubernetes_namespace)$NC
