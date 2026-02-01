#!/bin/bash
set -e -o pipefail

export COMPOSE_FILE="docker-compose.dev.yaml" 
export SERVICE_NAME="dev-app"
export DATABASE_NAME="dev-db"

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Start the database and wait for it to be healthy
docker compose -f $COMPOSE_FILE up -d --build $DATABASE_NAME --wait

# Wait for database to be ready and run migrations
./scripts/migrate.sh upgrade

# Now start the application
docker compose -f $COMPOSE_FILE up -d --build $SERVICE_NAME