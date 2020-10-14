#!/bin/bash

# Pulls a manifest of images from Docker Hub, tags them, and pushes them to 
# local registry (presumed to be localhost:5000).

registry=localhost:5000
declare -a images=(
                  "strimzi/kafka:0.19.0-kafka-2.5.0"
                  "strimzi/operator:0.19.0"
                  "strimzi/kafka-bridge:0.18.0"
                  "strimzi/jmxtrans:0.19.0"
                  )

for image in "${images[@]}"
do
  docker pull $image
  docker tag $image ${registry}/${image}
  docker push ${registry}/${image}
done
