#!/usr/bin/env bash


set -e
set -u
set -o pipefail

while getopts "hn:" opt; do
    case "$opt" in
    h)
      echo "Usage: $PURPLE$0 -n <namespace> <partial_pod_name>$NC"
      exit 0
      ;;
    n)
      namespace="$OPTARG"
        ;;
    *)
      echo -e "${RED}[!] illegal option!"
      exit 1
      ;;
    esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift  # shift passed '-n' and its argument


# DEBUG command line parsing
#echo -e "${GREEN}namespace:$namespace ${PURPLE}anything else:$1$NC\n"

partial_pod_name="$1"
echo -e "${GREEN}namespace:$namespace ${PURPLE}pod:$partial_pod_name$NC\n"

pod="$(kubectl get pod -o name -n $namespace | grep $partial_pod_name | head -n 1)"
volume_names="$(kubectl get $pod -o jsonpath='{.spec.volumes..name}' | tr ' ' ',')"

# DEBUG kubectl command output
#echo -e "volume names: $volume_names"
#echo -e "pod name: $pod"


set -x
kubectl -n "$namespace" annotate "$pod" backup.velero.io/backup-volumes="$volume_names" --overwrite
set +x

