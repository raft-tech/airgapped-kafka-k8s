#!/bin/bash

# local registry (defaults to be localhost:5000).
[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

# This assumes macOS sed. If on Linux, remove '' after the -i
sed -i '' "s/rook\//${REGISTRY}\/rook\//" rook/cluster/examples/kubernetes/cassandra/operator.yaml

kubectl apply -f rook/cluster/examples/kubernetes/cassandra/operator.yaml
