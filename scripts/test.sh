#!/bin/bash
set -e -o pipefail

export COMPOSE_FILE="docker-compose.test.yaml" 
export SERVICE_NAME="test-app"
export DATABASE_NAME="test-db"

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Stop and remove any existing test containers
docker compose -f $COMPOSE_FILE down --volumes --remove-orphans

# Start only the database first
docker compose -f $COMPOSE_FILE up -d --build $DATABASE_NAME

# Wait for database to be ready and run migrations
./scripts/migrate.sh upgrade 

# Now run the tests
docker compose -f $COMPOSE_FILE up --build --abort-on-container-exit --exit-code-from $SERVICE_NAME $SERVICE_NAME

# Clean up test containers after tests complete
docker compose -f $COMPOSE_FILE down --volumes --remove-orphans
