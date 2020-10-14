# airgapped-kafka-k8s

## Kafka images (on Docker Hub)
- strimzi/kafka:0.19.0-kafka-2.5.0
- strimzi/operator:0.19.0
- strimzi/kafka-bridge:0.18.0
- strimzi/jmxtrans:0.19.0

## Test steps
1. Start Docker for Desktop w/ k8s support enabled
2. Perform the following shell commands:
    ``` zsh
    # Setup
    export PROJECT=airgapped-kafka-k8s
    git clone https://github.com/raft-tech/$PROJECT
    cd $PROJECT

    # Start local registry and import images
    docker-compose up -d
    sh ./import_images.sh

    # Install Kafka Operator
    helm repo add strimzi https://strimzi.io/charts/
    helm install --name airgapped-kafka --set imageRepositoryOverride="localhost:5000/strimzi" --create-namespace -n operators strimzi/strimzi-kafka-operator

    # Check install
    helm ls
    kubectl get deploys -n operators
    kubectl get pods -n operators
    # If jq not installed, either "brew install jq" or remove "| jq" from below
    kubectl get pod -n operators $(kubectl get pods -n operators --no-headers -o custom-columns=":metadata.name") -o jsonpath='{$.spec.containers[*].env[3:]}' | jq
    # Confirm output has image values prepended with "localhost:5000/"
    
    ```
