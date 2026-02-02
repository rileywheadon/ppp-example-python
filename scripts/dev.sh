#!/bin/bash
set -e -o pipefail
source "scripts/config.sh"

# Start the database and wait for it to be healthy
docker compose -f $DEV_COMPOSE_FILE up -d $DEV_DATABASE_NAME --build --wait

# Wait for database to be ready and run migrations
COMPOSE_FILE=$DEV_COMPOSE_FILE SERVICE_NAME=$DEV_SERVICE_NAME ./scripts/migrate.sh upgrade

# Now start the application
docker compose -f $DEV_COMPOSE_FILE up -d $DEV_SERVICE_NAME --build