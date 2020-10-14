# airgapped-kafka-k8s

## Images on Docker Hub
### Kafka
- strimzi/kafka:0.19.0-kafka-2.5.0
- strimzi/operator:0.19.0
- strimzi/kafka-bridge:0.18.0
- strimzi/jmxtrans:0.19.0
### Rook
- rook/cassandra:v1.4.5
## Test steps
1. Start Docker for Desktop w/ k8s support enabled
2. Perform the following shell commands:
    ``` zsh
    # Setup
    export PROJECT=airgapped-kafka-k8s
    git clone --recurse-submodules --shallow-submodules https://github.com/raft-tech/$PROJECT
    cd $PROJECT

    # Start local registry and import images
    docker-compose up -d
    [export REGISTRY=<your-custom-registry> && ] sh ./import_images.sh

    # Install Kafka Operator (swap out localhost:5000 with your custom name if you're using one)
    helm repo add strimzi https://strimzi.io/charts/
    helm install --name airgapped-kafka --set imageRepositoryOverride="localhost:5000/strimzi" --create-namespace -n operators strimzi/strimzi-kafka-operator

    # Check install
    helm ls
    kubectl get deploys -n operators
    kubectl get pods -n operators
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n operators $(kubectl get pods -n operators --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/" 
    # or your custom registry name

    # Rook test
    [export REGISTRY=<your-custom-registry> && ] sh ./rook_local.sh
    kubectl get pods -n rook-cassandra-system
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n rook-cassandra-system $(kubectl get pods -n rook-cassandra-system --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/" 
    # or your custom registry name    
    ```
