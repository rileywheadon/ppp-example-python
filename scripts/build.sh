#!/bin/bash
set -e -o pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DOCKERHUB_USERNAME"
    exit 1
fi

DOCKERHUB_USERNAME=$1
TAG=$(yq e '.version' version.yaml)

# Enable BuildKit for faster builds
DOCKER_BUILDKIT=1

# Build versioned and latest images with BuildKit cache
docker build \
  --cache-from ${DOCKERHUB_USERNAME}/ppp-example-python:latest \
  -t ${DOCKERHUB_USERNAME}/ppp-example-python:${TAG} \
  -t ${DOCKERHUB_USERNAME}/ppp-example-python:latest \
  .

# Push both tags
docker push ${DOCKERHUB_USERNAME}/ppp-example-python:${TAG}
docker push ${DOCKERHUB_USERNAME}/ppp-example-python:latest


