#!/usr/bin/env bash

source ~/Documents/scripts/source-me_prompt-style.sh

tmux_id ()
{
    tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2
}

set_kubernetes_vars ()
{
   context="$(kubectl config current-context)"
   namespace="$(kubectl config get-contexts | grep \* | tr -s ' ' | cut -d ' ' -f5)"

   minikube_running="$(ps -ef | grep -v grep | grep minikube)"
   minikube_configured="$(kubectl config current-context | grep minikube)"
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

echo -en "[ $(tmux_id) |  $(custom_git_ps1) $(show_kubernetes_context)$(show_kubernetes_namespace)] "


#echo -en $(show_kubernetes_context)$YELLOW$(show_kubernetes_namespace)$NC
