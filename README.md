# airgapped-kafka-k8s

## Purpose
This repo tracks details for images necessary to run a proposed MVP Kafka + C* cluster on k8s. It provides automation and documents testing that ensures that containers of these images can run in an air-gapped environment with a basic pub/sub.

## Services Covered
- **Confluent Platform**
- **Apache Kafka**
- **Apache Cassandra**
- Apache NiFi
- Apache Spark
- Dask (Python Parallel Computing)

## Image Manifest

| Service                 | Component(s)                              | Image                                                      | Version | License              | URL                                                                                     | Needed for MVP? | In IronBank? |
|-------------------------|-------------------------------------------|------------------------------------------------------------|---------|----------------------|-----------------------------------------------------------------------------------------|-----------------|--------------|
| [Kafka](#kafka)         | Confluent Zookeeper                       | `confluentinc/cp-zookeeper:5.5.2`                          | 5.5.2   | Commercial           | https://github.com/confluentinc/cp-docker-images/tree/5.3.3-post/debian/zookeeper       | Yes             | Yes          |
|                         | Confluent Kafka                           | `confluentinc/cp-kafka:5.5.2`                              | 5.5.2   | Commercial           | https://github.com/confluentinc/cp-docker-images/tree/5.3.3-post/debian/kafka           | Yes             | Yes          |
|                         | Confluent Schema Registry                 | `confluentinc/cp-schema-registry:5.5.2`                    | 5.5.2   | Commercial           | https://github.com/confluentinc/cp-docker-images/tree/5.3.3-post/debian/schema-registry | Yes             | Yes          |
|                         | Confluent KSQLdb Server                   | `confluentinc/cp-ksqldb-server:5.5.2`                      | 5.5.2   | Commercial           |                                                                                         | Yes             | Yes          |
|                         | Confluent KSQLdb CLI                      | `confluentinc/cp-ksqldb-cli:5.5.2`                         | 5.5.2   | Commercial           |                                                                                         | Yes             | Yes          |
|                         | Apache Kafka core; Zookeeper              | `strimzi/kafka:0.19.0-kafka-2.5.0`                         | 0.19.0  | Apache License 2.0   | https://github.com/strimzi/strimzi-kafka-operator                                       | Yes             | No           |
|                         | Kafka Operator                            | `strimzi/operator:0.19.0`                                  | 0.19.0  | Apache License 2.0   | https://github.com/strimzi/strimzi-kafka-operator                                       | Yes             | No           |
|                         | Kafka Bridge                              | `strimzi/kafka-bridge:0.18.0`                              | 0.18.0  | Apache License 2.0   | https://github.com/strimzi/strimzi-kafka-operator                                       | Yes             | No           |
|                         | JMX interface                             | `strimzi/jmxtrans:0.19.0`                                  | 0.19.0  | Apache License 2.0   | https://github.com/strimzi/strimzi-kafka-operator                                       | Yes             | No           |
|                         | Kafka Dashboard                           | `tchiotludo/akhq:latest`                                   | latest  | Apache License 2.0   | https://github.com/tchiotludo/akhq                                                      | Yes             | No           |
| [Cassandra](#cassandra) | Rook Cassandra Operator                   | `rook/cassandra:v1.4.5`                                    | 1.4.5   | Apache License 2.0   | https://github.com/rook/rook                                                            | Yes             | No           |
| [Spark](#spark)         | Spark Operator                            | `gcr.io/spark-operator/spark-operator:v1beta2-1.2.1-3.0.0` | v1beta2 | Apache License 2.0   | https://github.com/GoogleCloudPlatform/spark-on-k8s-operator                            | No              | No           |
|                         | Apache Spark core                         | `gcr.io/spark-operator/spark:v3.0.0`                       | 3.0.0   | Apache License 2.0   | https://github.com/GoogleCloudPlatform/spark-on-k8s-operator                            | No              | No           |
| [NiFi](#nifi)           | Apache NiFi                               | `apache/nifi:1.12.1`                                       | 1.12.1  | Apache License 2.0   | https://github.com/apache/nifi                                                          | No              | No           |
|                         | NiFi Registry                             | `apache/nifi-registry:0.8.0`                               | 0.8.0   | Apache License 2.0   | https://github.com/apache/nifi-registry                                                 | No              | No           |
|                         | MiNiFi                                    | `apache/nifi-minifi:0.5.0`                                 | 0.5.0   | Apache License 2.0   | https://github.com/apache/nifi-minifi                                                   | No              | No           |
|                         | MiNiFi Command & Control (C2)             | `apache/nifi-minifi-c2:0.5.0`                              | 0.5.0   | Apache License 2.0   | https://github.com/apache/nifi-minifi/tree/master/minifi-c2                             | No              | No           |
|                         | MiNiFi C++ Implementation                 | `apache/nifi-minifi-cpp:0.6.0`                             | 0.6.0   | Apache License 2.0   | https://github.com/apache/nifi-minifi-cpp                                               | No              | No           |
| [Dask](#dask)           | Dask Standalone (single user)             | `daskdev/dask:2.30.0`                                      | 2.30.0  | BSD 3-Clause License | https://github.com/dask/dask-docker                                                     | No              | No           |
|                         | Dask Gateway Server (multi-user)          | `daskgateway/dask-gateway-server:0.8.0`                    | 0.8.0   | BSD 3-Clause License | https://github.com/dask/dask-gateway/tree/master/dask-gateway-server                    | No              | No           |
|                         | Dask Gateway (client)                     | `daskgateway/dask-gateway:0.8.0`                           | 0.8.0   | BSD 3-Clause License | https://github.com/dask/dask-gateway/tree/master/dask-gateway                           | No              | No           |
|                         | Jupyter Hub (dependency for Dask Gateway) | `jupyterhub/k8s-hub:0.9.1`                                 | 0.9.1   | BSD 3-Clause License | https://github.com/apache/nifi-minifi-cpp                                               | No              | No           |

## Service Details

### Kafka
[Confluent Platform](https://docs.confluent.io/current/getting-started.html) is the commercial version of Kafka, maintained and sold by Confluent. 
[Strimzi](https://strimzi.io/docs/operators/latest/deploying.html#deploying-cluster-operator-helm-chart-str) is an OSS Kubernetes Operator for Apache Kafka.
Strimzi is licensed under the [Apache License 2.0](https://github.com/strimzi/strimzi-kafka-operator/blob/master/LICENSE).
AKHQ is licensed under the [Apache License 2.0](https://github.com/tchiotludo/akhq/blob/dev/LICENSE).

### Cassandra
[Rook](https://rook.io/docs/rook/v1.4/cassandra.html) is an OSS Kubernetes Operator for Apache Cassandra (C*).
Rook is licensed under the [Apache License 2.0](https://github.com/rook/rook/blob/master/LICENSE).

### Spark
[Spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/quick-start-guide.md) is an unofficial project by Google Cloud Platform for Apache Spark. 
Spark-on-k8s-operator is licensed under the [Apache License 2.0](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/LICENSE).

### NiFi
All NiFi related components are licensed under the [Apache License 2.0](https://github.com/apache/nifi/blob/main/LICENSE).

### Dask
[Dask](https://docs.dask.org/en/latest/) is a project by the NumPy, Pandas, Jupyter, Scikit-Learn developer community. It is a community-governed project, and is fiscally sponsored by NumFOCUS - the 501(c)(3) sponsor of NumPy, Pandas, and Jupyter.
Dask is licensed under the [BSD 3-Clause License](https://github.com/dask/dask/blob/master/LICENSE.txt).
JupyterHub is licensed under the [BSD 3-Clause License](https://github.com/jupyterhub/jupyterhub/blob/master/COPYING.md).

## Test steps (WIP)
1. Start Docker for Desktop w/ k8s support enabled
2. Perform the following shell commands:
    ``` zsh
    # Setup
    export PROJECT=airgapped-kafka-k8s
    git clone --recurse-submodules --shallow-submodules https://github.com/raft-tech/$PROJECT
    cd $PROJECT

    # Start local registry and import images
    docker-compose up -d
    [export REGISTRY=<your-custom-registry> && ] sh ./scripts/import_images.sh

    # Kafka test
    [export REGISTRY=<your-custom-registry> && ] sh ./scripts/kafka_local.sh

    # Check install
    kubectl get deployments
    helm ls -n operators
    kubectl get deployments -n operators
    kubectl get pods -n operators
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n operators $(kubectl get pods -n operators --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/" 
    # or your custom registry name

    # NiFi test
    #[export REGISTRY=<your-custom-registry> && ] sh ./scripts/nfi_local.sh
    #kubectl get pods -n nifi

    # Rook test
    [export REGISTRY=<your-custom-registry> && ] sh ./scripts/rook_local.sh
    kubectl get pods -n rook-cassandra-system
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n rook-cassandra-system $(kubectl get pods -n rook-cassandra-system --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/" 
    # or your custom registry name    

    # Spark test
    # Install Spark Operator
    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm install incubator/sparkoperator --generate-name --namespace operators --set sparkJobNamespace=default

    # Check install
    helm ls -n operators
    kubectl get deployments -n operators
    kubectl get pods -n operators
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n operators $(kubectl get pods -n operators --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/" 
    # or your custom registry name
    [export REGISTRY=<your-custom-registry> && ] sh ./scripts/spark_local.sh
    kubectl get sparkapplications spark-pi -o=yaml
    ```
