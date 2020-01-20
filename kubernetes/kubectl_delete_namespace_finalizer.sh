#!/usr/bin/env bash

namespace="$1"
finalizer_to_remove="${2:-kubernetes}"
tmp_dir="$(mktemp -d)"
filename="$tmp_dir/$namespace".yaml

trap "kill %%  2>/dev/null; rm -rf $tmp_dir" EXIT

kubectl proxy &
kubectl get namespace "$namespace" -o yaml > "$filename"

sed -i "/- $finalizer_to_remove/d"  "$filename"

unset HTTPS_PROXY HTTP_PROXY ALL_PROXY
curl -X PUT --data-binary @"$filename" http://localhost:8001/api/v1/namespaces/"$namespace"/finalize -H "Content-Type: application/yaml"
echo

direnv allow

