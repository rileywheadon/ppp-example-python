#!/bin/bash
set -e -o pipefail
source "scripts/config.sh"

DOMAIN=$1
echo "Starting deployment to $DOMAIN"

if [ "$DOMAIN" = "localhost" ]; then
    TLS_CONFIG=""
    WWW_CONFIG=""
else 
    TLS_CONFIG="tls $EMAIL"
    WWW_CONFIG="www.{$DOMAIN} { redir https://{$DOMAIN}{uri} permanent }"
fi

# Stop the service container
docker compose stop $SERVICE_NAME 

# Start the database and Caddy
DOMAIN=$DOMAIN TLS_CONFIG=$TLS_CONFIG WWW_CONFIG=$WWW_CONFIG docker compose up -d $DATABASE_NAME $CADDY_NAME --wait

# Wait for database to be ready and run migrations
COMPOSE_FILE=$COMPOSE_FILE SERVICE_NAME=$SERVICE_NAME ./scripts/migrate.sh upgrade

# Now start the application
docker compose up -d $SERVICE_NAME