#!/usr/bin/env bash


source ~/Documents/scripts/kubernetes/source-me/common_functions.sh

set -e
#set -u
set -o pipefail


usage()
{
  echo "Usage: $PURPLE$0 -n <namespace> [-e <do_not_match_regex>] <partial_pod_name>$NC"
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

