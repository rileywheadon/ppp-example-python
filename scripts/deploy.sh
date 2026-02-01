#!/bin/bash
set -e -o pipefail

export COMPOSE_FILE="docker-compose.yaml" 
export SERVICE_NAME="app"
export DATABASE_NAME="db"

export DOCKERHUB_USERNAME="rileywheadon"
export TAG=$(yq e '.version' version.yaml)

# Stop any existing containers
docker compose down 

# Start only the database first
docker compose up -d $DATABASE_NAME --wait

# Wait for database to be ready and run migrations
./scripts/migrate.sh upgrade

# Now start the application
docker compose up -d $SERVICE_NAME