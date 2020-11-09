#!/bin/bash

# Pulls a manifest of images from Docker Hub, tags them, and pushes them to 
# local registry (defaults to be localhost:5000).

[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

[ -z "$CP_VERSION" ] && CP_VERSION=5.5.2
[ -z "$CP_OPERATOR_VERSION" ] && CP_OPERATOR_VERSION=5.5.2.0
[ -z "$CP_OPERATOR_SERVICE" ] && CP_OPERATOR_SERVICE=0.419.0

declare -a images=()

declare -a images_cassandra=(
                  "rook/cassandra:v1.4.5"
                  )

declare -a images_cp=(
                  "confluentinc/cp-zookeeper:${CP_VERSION}"
                  "confluentinc/cp-kafka:${CP_VERSION}"
                  "confluentinc/cp-schema-registry:${CP_VERSION}"
                  "confluentinc/cp-ksqldb-server:${CP_VERSION}"
                  "confluentinc/cp-ksqldb-cli:${CP_VERSION}"
                  "confluentinc/cp-kafka-connect:${CP_VERSION}"
                  "confluentinc/cp-enterprise-control-center:${CP_VERSION}"
                  "confluentinc/cp-operator-service:${CP_OPERATOR_SERVICE}"
                  "confluentinc/cp-init-container-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-server-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-ksqldb-server-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-schema-registry-operator:${CP_OPERATOR_VERSION}"
                  "confluentinc/cp-enterprise-control-center-operator:${CP_VERSION}"
                  "confluentinc/cp-zookeeper-operator:${CP_OPERATOR_VERSION}"
                  )

declare -a images_ak=(
                  "strimzi/kafka:0.19.0-kafka-2.5.0"
                  "strimzi/operator:0.19.0"
                  "strimzi/kafka-bridge:0.18.0"
                  "strimzi/jmxtrans:0.19.0"
                  "tchiotludo/akhq:latest"
                  )

declare -a images_nifi=(
                  "apache/nifi:1.12.1"
                  "apache/nifi-registry:0.8.0"
                  "apache/nifi-minifi:0.5.0"
                  "apache/nifi-minifi-c2:0.5.0"
                  "apache/nifi-minifi-cpp:0.6.0"
                  )

declare -a images_spark=(
                  "gcr.io/spark-operator/spark-operator:v1beta2-1.2.1-3.0.0"
                  "gcr.io/spark-operator/spark:v3.0.0"
                  )

declare -a images_dask=(
                  "daskdev/dask:2.30.0"
                  "daskgateway/dask-gateway-server:0.8.0"
                  "daskgateway/dask-gateway:0.8.0"
                  "jupyterhub/k8s-hub:0.9.1"
                  )

function do_help {
  echo ""
  echo "$(basename "$0") [-h] [-a | --skip-cassandra] [c | --skip-cp] [d | --skip-dask] [k | --skip-ak] [n | --skip-nifi] [s | --skip-spark] -- script to setup, test, and teardown kafka"
  echo ""
  echo "where:"
  echo "    -h  show this help text"
  echo "    -a or --skip-cassandra  skip Cassandra images"
  echo "    -c or --skip-cp  skip Confluent Platform images"
  echo "    -d or --skip-dask  skip Dask images"
  echo "    -k or --skip-ak  skip Apache Kafka images"
  echo "    -n or --skip-nifi  skip NiFi images"
  echo "    -s or --skip-spark  skip Spark images"
  echo ""
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) do_help; exit 1 ;;
        -a|--skip-cassandra) skip_cassandra=1 ;;
        -c|--skip-cp) skip_cp=1 ;;
        -d|--skip-dask) skip_dask=1 ;;
        -k|--skip-ak) skip_ak=1 ;;
        -n|--skip-nifi) skip_nifi=1 ;;
        -s|--skip-spark) skip_spark=1 ;;
        *) echo "Unknown parameter passed: $1"; do_help; exit 1 ;;
    esac
    shift
done

if [[ "$skip_cassandra" == "1" ]]; then
  echo "Skipping Cassandra..."
  sleep 1
else
  images=(${images[@]} ${images_cassandra[@]})
fi

if [[ "$skip_cp" == "1" ]]; then
  echo "Skipping Confluent Platform..."
  sleep 1
else
  images=(${images[@]} ${images_cp[@]})
fi

if [[ "$skip_dask" == "1" ]]; then
  echo "Skipping Dask..."
  sleep 1
else
  images=(${images[@]} ${images_dask[@]})
fi

if [[ "$skip_ak" == "1" ]]; then
  echo "Skipping Apache Kafka..."
  sleep 1
else
  images=(${images[@]} ${images_ak[@]})
fi

if [[ "$skip_nifi" == "1" ]]; then
  echo "Skipping NiFi..."
  sleep 1
else
  images=(${images[@]} ${images_nifi[@]})
fi

if [[ "$skip_spark" == "1" ]]; then
  echo "Skipping Spark..."
  sleep 1
else
  images=(${images[@]} ${images_spark[@]})
fi

for image in "${images[@]}"
do
  docker pull $image
  docker tag $image ${REGISTRY}/${image}
  docker push ${REGISTRY}/${image}
done
