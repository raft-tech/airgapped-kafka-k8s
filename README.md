# airgapped-kafka-k8s

## Services Covered - ([Manifest of images](https://github.com/raft-tech/airgapped-kafka-k8s/docs/images.md))
- Apache Cassandra
- Apache Kafka
- Apache NiFi
- Apache Spark
- Dask (Python Parallel Computing)

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
