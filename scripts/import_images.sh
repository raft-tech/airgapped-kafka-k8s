#!/bin/bash

# Pulls a manifest of images from Docker Hub, tags them, and pushes them to 
# local registry (defaults to be localhost:5000).

[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

declare -a images=(
                  "strimzi/kafka:0.19.0-kafka-2.5.0"
                  "strimzi/operator:0.19.0"
                  "strimzi/kafka-bridge:0.18.0"
                  "strimzi/jmxtrans:0.19.0"
                  "tchiotludo/akhq:latest"
                  "apache/nifi:1.12.1"
                  "rook/cassandra:v1.4.5"
                  "gcr.io/spark-operator/spark-operator:v1beta2-1.2.1-3.0.0"
                  "gcr.io/spark-operator/spark:v3.0.0"
                  )

for image in "${images[@]}"
do
  docker pull $image
  docker tag $image ${REGISTRY}/${image}
  docker push ${REGISTRY}/${image}
done
