#!/bin/bash

# local registry (defaults to be localhost:5000).
[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

# This assumes macOS sed. If on Linux, remove '' after the -i
sed -i '' "s/gcr.io\/spark-operator\//${REGISTRY}\/spark-operator\//" spark-on-k8s-operator/examples/spark-pi.yaml

kubectl apply -f spark-on-k8s-operator/examples/spark-pi.yaml
