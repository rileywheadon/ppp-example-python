#!/bin/bash
set -e -o pipefail
source "scripts/config.sh"

# Stop and remove any existing test containers
docker compose -f $TEST_COMPOSE_FILE down --volumes --remove-orphans

# Start only the database first
docker compose -f $TEST_COMPOSE_FILE up -d $TEST_DATABASE_NAME --build --wait

# Wait for database to be ready and run migrations
COMPOSE_FILE=$TEST_COMPOSE_FILE SERVICE_NAME=$TEST_SERVICE_NAME ./scripts/migrate.sh upgrade

# Now run the tests
docker compose -f $TEST_COMPOSE_FILE up $TEST_SERVICE_NAME \
  --build \
  --abort-on-container-exit \
  --exit-code-from $TEST_SERVICE_NAME

# Clean up test containers after tests complete
docker compose -f $TEST_COMPOSE_FILE down --volumes --remove-orphans
