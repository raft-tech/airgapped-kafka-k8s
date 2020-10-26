# Image Manifest for airgapped-kafka-k8s

| Service   | Component(s)                              | Image                                                    | Version | URL                                                                  | In IronBank? |
|-----------|-------------------------------------------|----------------------------------------------------------|---------|----------------------------------------------------------------------|--------------|
| [Kafka](#Kafka)     | Apache Kafka core; Zookeeper              | strimzi/kafka:0.19.0-kafka-2.5.0                         | 0.19.0  | https://github.com/strimzi/strimzi-kafka-operator                    | No           |
|           | Kafka Operator                            | strimzi/operator:0.19.0                                  | 0.19.0  | https://github.com/strimzi/strimzi-kafka-operator                    | No           |
|           | Kafka Bridge                              | strimzi/kafka-bridge:0.18.0                              | 0.18.0  | https://github.com/strimzi/strimzi-kafka-operator                    | No           |
|           | JMX interface                             | strimzi/jmxtrans:0.19.0                                  | 0.19.0  | https://github.com/strimzi/strimzi-kafka-operator                    | No           |
|           | Kafka Dashboard                           | tchiotludo/akhq:latest                                   | latest  | https://github.com/tchiotludo/akhq                                   | No           |
| [Cassandra](#cassandra) | Cassandra Operator                        | rook/cassandra:v1.4.5                                    | 1.4.5   | https://github.com/rook/rook                                         | No           |
| [Spark](#spark)     | Rook Spark Operator                       | gcr.io/spark-operator/spark-operator:v1beta2-1.2.1-3.0.0 | v1beta2 | https://github.com/GoogleCloudPlatform/spark-on-k8s-operator         | No           |
|           | Apache Spark core                         | gcr.io/spark-operator/spark:v3.0.0                       | 3.0.0   | https://github.com/GoogleCloudPlatform/spark-on-k8s-operator         | No           |
| [NiFi](#nifi)      | Apache NiFi                               | apache/nifi:1.12.1                                       | 1.12.1  | https://github.com/apache/nifi                                       | No           |
|           | NiFi Registry                             | apache/nifi-registry:0.8.0                               | 0.8.0   | https://github.com/apache/nifi-registry                              | No           |
|           | MiNiFi                                    | apache/nifi-minifi:0.5.0                                 | 0.5.0   | https://github.com/apache/nifi-minifi                                | No           |
|           | MiNiFi Command & Control (C2)             | apache/nifi-minifi-c2:0.5.0                              | 0.5.0   | https://github.com/apache/nifi-minifi/tree/master/minifi-c2          | No           |
|           | MiNiFi C++ Implementation                 | apache/nifi-minifi-cpp:0.6.0                             | 0.6.0   | https://github.com/apache/nifi-minifi-cpp                            | No           |
| [Dask](#dask)      | Dask Standalone (single user)             | daskdev/dask:2.30.0                                      | 2.30.0  | https://github.com/dask/dask-docker                                  | No           |
|           | Dask Gateway Server (multi-user)          | daskgateway/dask-gateway-server:0.8.0                    | 0.8.0   | https://github.com/dask/dask-gateway/tree/master/dask-gateway-server | No           |
|           | Dask Gateway (client)                     | daskgateway/dask-gateway:0.8.0                           | 0.8.0   | https://github.com/dask/dask-gateway/tree/master/dask-gateway        | No           |
|           | Jupyter Hub (dependency for Dask Gateway) | jupyterhub/k8s-hub:0.9.1                                 | 0.9.1   | https://github.com/apache/nifi-minifi-cpp                            | No           |

---
## Service Details

### Kafka
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
