#!/bin/bash
set -e -o pipefail

# Define common configuration variables that are shared across scripts
export MIGRATIONS_DIR="./src/migrations/versions"
export COMPOSE_FILE="docker-compose.yaml"
export DEV_COMPOSE_FILE="docker-compose.dev.yaml"
export TEST_COMPOSE_FILE="docker-compose.test.yaml"

export SERVICE_NAME="app"
export DATABASE_NAME="db"
export CADDY_NAME="caddy"

export DEV_SERVICE_NAME="dev-app"
export DEV_DATABASE_NAME="dev-db"

export TEST_SERVICE_NAME="test-app"
export TEST_DATABASE_NAME="test-db"

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Configuration for deployment
export DOMAIN="example.rwheadon.dev"
export DOCKERHUB_USERNAME="rileywheadon"
export EMAIL="rileywheadon@gmail.com"
export TAG=$(yq e '.version' version.yaml)