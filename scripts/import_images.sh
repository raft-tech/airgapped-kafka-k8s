#!/bin/bash

# Pulls a manifest of images from Docker Hub, tags them, and pushes them to 
# local registry (defaults to be localhost:5000).

[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

[ -z "$CP_VERSION" ] && CP_VERSION=5.5.2
[ -z "$CP_OPERATOR_VERSION" ] && CP_OPERATOR_VERSION=5.5.2.0
[ -z "$CP_OPERATOR_SERVICE" ] && CP_OPERATOR_SERVICE=0.419.0

declare -a images=(
                  "confluentinc/cp-zookeeper:${CP_VERSION}"
                  "confluentinc/cp-kafka:${CP_VERSION}"
                  "confluentinc/cp-schema-registry:${CP_VERSION}"
                  "confluentinc/cp-ksqldb-server:${CP_VERSION}"
                  "confluentinc/cp-ksqldb-cli:${CP_VERSION}"
                  "confluentinc/cp-operator-service:${CP_OPERATOR_SERVICE}"
                  "confluentinc/cp-init-container-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-server-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-ksqldb-server-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-schema-registry-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-zookeeper-operator:${CP_OPERATOR_VERSION}"
                  "strimzi/kafka:0.19.0-kafka-2.5.0"
                  "strimzi/operator:0.19.0"
                  "strimzi/kafka-bridge:0.18.0"
                  "strimzi/jmxtrans:0.19.0"
                  "tchiotludo/akhq:latest"
                  "apache/nifi:1.12.1"
                  "apache/nifi-registry:0.8.0"
                  "apache/nifi-minifi:0.5.0"
                  "apache/nifi-minifi-c2:0.5.0"
                  "apache/nifi-minifi-cpp:0.6.0"
                  "rook/cassandra:v1.4.5"
                  "gcr.io/spark-operator/spark-operator:v1beta2-1.2.1-3.0.0"
                  "gcr.io/spark-operator/spark:v3.0.0"
                  "daskdev/dask:2.30.0"
                  "daskgateway/dask-gateway-server:0.8.0"
                  "daskgateway/dask-gateway:0.8.0"
                  "jupyterhub/k8s-hub:0.9.1"
                  )

for image in "${images[@]}"
do
  docker pull $image
  docker tag $image ${REGISTRY}/${image}
  docker push ${REGISTRY}/${image}
done
