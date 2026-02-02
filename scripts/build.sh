#!/bin/bash
set -e -o pipefail
source "scripts/config.sh"

# Build versioned and latest images with BuildKit cache
docker build \
  --cache-from $DOCKERHUB_USERNAME/ppp-example-python:latest \
  -t $DOCKERHUB_USERNAME/ppp-example-python:$TAG \
  -t $DOCKERHUB_USERNAME/ppp-example-python:latest \
  .

# Push both tags
docker push $DOCKERHUB_USERNAME/ppp-example-python:$TAG
docker push $DOCKERHUB_USERNAME/ppp-example-python:latest


