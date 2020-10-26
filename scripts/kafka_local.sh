#!/bin/bash

function do_help {
  echo ""
  echo "$(basename "$0") [-h] [-s | --setup] [t | --teardown] -- script to setup, test, and teardown kafka"
  echo ""
  echo "where:"
  echo "    -h  show this help text"
  echo "    -s or --setup  skip setup"
  echo "    -t or --teardown  skip teardown"
  echo ""
}

function do_setup {
  # Install Kafka Operator
  helm repo add strimzi https://strimzi.io/charts/
  helm install strimzi-cluster-operator --set imageRepositoryOverride="${REGISTRY}/strimzi" --set watchAnyNamespace=true --create-namespace -n operators strimzi/strimzi-kafka-operator
  kubectl rollout status --timeout=2m -n operators deployment/strimzi-cluster-operator
  if [ $? -ne 0 ]; then
    echo "Strimzi Operator deployment failed! Exiting..."
    exit 1
  fi

  # Start Kafka test cluster
  kubectl apply -f strimzi-kafka-operator/examples/kafka/kafka-ephemeral.yaml
  echo "Waiting for cluster to be ready (this will take several minutes)..."
  if !( kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s ); then
    echo "Failed! Exiting..."
    exit 1
  fi

  # This assumes macOS sed. If on Linux, remove '' after the -i
  sed -i '' 's/kafka:9092/my-cluster-kafka-bootstrap:9092/' akhq/helm/akhq/values.yaml

  # Install Apache Kafka HQ (AKHQ)
  pushd akhq/helm/akhq
  helm install akhq --set image.repository="${REGISTRY}/tchiotludo/akhq" .
  popd
  kubectl rollout status --timeout=2m deployment/akhq
  if [ $? -ne 0 ]; then
    echo "akhq deployment failed! Exiting..."
    exit 1
  fi
  akhq_pod=$(kubectl get pod -l app.kubernetes.io/name=akhq -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward $akhq_pod 8080:8080 > /dev/null &
  pf_pid=$(echo $!)
  printf "Kafka HQ is accessible from http://localhost:8080\n\n"
}

function do_teardown {
  echo "Shutting down the Kafka Consumer and Producer"
  kill $producer_pid  # just in case it's still around
  kubectl delete kafka-consumer
  kubectl delete kafka-producer
  kill -9 $pf_pid

  echo "Tearing down AKHQ"
  helm delete akhq

  echo "Tearing down Kafka and Zookeeper clusters"
  kubectl delete -f strimzi-kafka-operator/examples/kafka/kafka-ephemeral.yaml
  sleep 60
  echo "Removing kakfa operator"
  helm delete -n operators strimzi-cluster-operator
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) do_help; exit 1 ;;
        -s|--setup) setup=1 ;;
        -t|--teardown) teardown=1 ;;
        *) echo "Unknown parameter passed: $1"; do_help; exit 1 ;;
    esac
    shift
done

# local registry (defaults to be localhost:5000).
[ -z "$REGISTRY" ] && REGISTRY=localhost:5000

if [[ "$setup" == "1" ]]; then
  echo "Skipping setup..."
  sleep 3
else
  do_setup
fi

echo "Starting a Kafka Consumer and Producer. Verify that messages are working."
# Start a producer (which will create our topic)
kubectl run kafka-producer --image=localhost:5000/strimzi/kafka:0.19.0-kafka-2.5.0 --restart=Never -- /bin/bash -c "while true; do sleep 30; done;"
kubectl exec -t kafka-producer -- /bin/bash -c 'for x in {1..59}; do echo $(date); sleep 5; done | bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic' > /dev/null &
producer_pid=$(echo $!)  # get pid to kill this just in case
timeout 300s bash -c "kubectl run kafka-consumer -it --image=${REGISTRY}/strimzi/kafka:0.19.0-kafka-2.5.0 --rm --restart=Never -- 'bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning'"

if [[ "$teardown" == "1" ]]; then
  echo "Skipping teardown..."
  sleep 3
else
  do_teardown
fi
