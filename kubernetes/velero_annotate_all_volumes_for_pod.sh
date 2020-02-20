#!/usr/bin/env bash


source ~/Documents/scripts/kubernetes/source-me_common_functions.sh

set -e
set -u
set -o pipefail


usage()
{
  echo "Usage: $PURPLE$0 -n <namespace> <partial_pod_name>$NC"
}

get_pod()
{
  local partial_pod_name="$1"
  local do_not_match="$2"
  if [ -n "$namespace" ]; then
    kubectl get pod -o name -n "$namespace" | grep -vE "$do_not_match"  | grep "$partial_pod_name"  | head -n 1
  else
    kubectl get pod -o name | grep -vE "$do_not_match"  | grep "$partial_pod_name"  | head -n 1
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

while getopts "hn:e:" opt; do  # ':' signify that a given flag takes an argument
    case "$opt" in
    h)
      usage
      exit 0
      ;;
    e)
      do_not_match="$OPTARG"
      ;;
    n)
      namespace="$OPTARG"
      ;;
    *)
      echo -e "${RED}[!] illegal option!"
      usage
      exit 1
      ;;
    esac
done

shift $((OPTIND - 1))
#echo "remainder: ${RED}$@$NC"

partial_pod_name="$1"
echo -e "${GREEN}namespace:$namespace ${PURPLE}pod:$partial_pod_name$NC ${PURPLE}do_not_match:$do_not_match\n"

pod="$(get_pod $partial_pod_name $do_not_match)"
volume_name_separator=','
volume_names="$(get_pod_volumes $volume_name_separator)"

set -x
kubectl -n "$namespace" annotate "$pod" backup.velero.io/backup-volumes="$volume_names" --overwrite
set +x

