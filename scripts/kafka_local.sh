#!/bin/bash

# local registry (defaults to be localhost:5000).
[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

# Install Kafka Operator
helm repo add strimzi https://strimzi.io/charts/
helm install airgapped-kafka --set imageRepositoryOverride="${REGISTRY}/strimzi" --set watchAnyNamespace=true --create-namespace -n operators strimzi/strimzi-kafka-operator

# Start Kafka test cluster
kubectl apply -f strimzi-kafka-operator/examples/kafka/kafka-ephemeral.yaml
echo "Waiting for cluster to be ready (this will take several minutes)..."
if !( kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s ); then
  echo "Failed! Exiting..."
  exit 1
fi

# Start a producer (which will create our topic)
kubectl run kafka-producer --image=localhost:5000/strimzi/kafka:0.19.0-kafka-2.5.0 --restart=Never -- /bin/bash -c "while true; do sleep 30; done;"

# Install Apache Kafka HQ (AKHQ)

# This assumes macOS sed. If on Linux, remove '' after the -i
sed -i '' 's/kafka:9092/my-cluster-kafka-bootstrap:9092/' akhq/helm/akhq/values.yaml

pushd akhq/helm/akhq
helm install akhq --set image.repository="${REGISTRY}/tchiotludo/akhq" .
popd
akhq_pod=$(kubectl get pod -l app.kubernetes.io/name=akhq -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $akhq_pod 8080:8080 > /dev/null &

echo "Starting a Kafka Consumer and Producer. Verify that messages are working."
echo "Kafka HQ is accessible from http://localhost:8080"
kubectl exec -t kafka-producer -- /bin/bash -c 'for x in {1..59}; do echo $(date); sleep 5; done | bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic' > /dev/null &
kubectl run kafka-consumer -it --image=localhost:5000/strimzi/kafka:0.19.0-kafka-2.5.0 --rm --restart=Never -- 'bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning' &

sleep 300

echo "Shutting down the Kafka Consumer and Producer"
kubectl delete kafka-consumer
kubectl delete kafka-producer

