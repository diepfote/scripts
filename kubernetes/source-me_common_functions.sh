#!/usr/bin/env bash


get_pod()
{
  local partial_pod_name="$1"
  do_not_match="$2"
  if [ -n "$namespace" ]; then
    kubectl get pod -o name -n "$namespace" | grep -vE "$do_not_match"  | grep "$partial_pod_name"  | head -n 1
  else
    kubectl get pod -o name | grep -vE "$do_not_match"  | grep "$partial_pod_name"  | head -n 1
  fi
}

get_pod_volumes()
{
  local separator="$1"

  [[ -z "$pod" ]] && pod="$2"

  if [ -n "$namespace" ]; then
    kubectl get "$pod" -n "$namespace" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  else
    kubectl get "$pod" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  fi
}

