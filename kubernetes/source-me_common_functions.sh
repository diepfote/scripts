#!/usr/bin/env bash


get_pod()
{
  partial_pod_name="$1"
  if [ -n "$namespace" ]; then
    kubectl get pod -o name -n $namespace | grep $partial_pod_name | head -n 1
  else
      kubectl get pod -o name | grep $partial_pod_name | head -n 1
  fi
}

get_pod_volumes()
{
  separator="$1"
  
  [[ -z "$pod" ]] && pod="$2"

  if [ -n "$namespace" ]; then
    kubectl get "$pod" -n "$namespace" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  else
    kubectl get "$pod" -o jsonpath='{.spec.volumes..name}' | tr ' ' "$separator"
  fi
}

