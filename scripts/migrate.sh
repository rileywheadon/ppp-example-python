#!/bin/bash
set -e -o pipefail

if [ -z "$COMPOSE_FILE" ]; then
    echo "Error: COMPOSE_FILE environment variable is not set."
    exit 1
fi

if [ -z "$SERVICE_NAME" ]; then
    echo "Error: SERVICE_NAME environment variable is not set."
    exit 1
fi

# Helper function to run alembic commands via docker compose
run_alembic() {
    docker compose -f $COMPOSE_FILE run --rm $SERVICE_NAME alembic -c src/alembic.ini "$@" 2>/dev/null
}

# Helper function to get current migration number
get_migration_number() {
    if [ -d "$MIGRATIONS_DIR" ]; then
        find "$MIGRATIONS_DIR" -name "*.py" -not -path "*/__pycache__/*" | \
        sed 's/.*\/\([0-9]\{4\}\)_.*/\1/' | \
        grep -E '^[0-9]{4}$' | \
        sort -n | \
        tail -1
    else
        echo ""
    fi
}

# Helper function to get next migration number
get_next_migration_number() {
    CURRENT_NUM=$(get_migration_number)
    if [ -z "$CURRENT_NUM" ]; then
        echo "0001"
    else
        printf "%04d" $((10#$CURRENT_NUM + 1))
    fi
}

if [ "$1" = "init" ]; then
    echo "Initializing Alembic..."
    run_alembic init migrations
elif [ "$1" = "generate" ] && [ -n "$2" ]; then
    echo "Generating migration: $2"
    NEXT_NUM=$(get_next_migration_number)   
    run_alembic revision -m "$2" --rev-id="$NEXT_NUM"
    sudo chown $USER:$USER ./src/migrations/versions/*.py 
elif [ "$1" = "upgrade" ]; then
    echo "Upgrading database to head..."
    run_alembic upgrade head
elif [ "$1" = "downgrade" ]; then
    echo "Downgrading database by 1 revision..."
    run_alembic downgrade -1
elif [ "$1" = "current" ]; then
    echo "Current database revision:"
    run_alembic current
elif [ "$1" = "history" ]; then
    echo "Migration history:"
    run_alembic history
else
    echo "Usage: $0 {init|generate|upgrade|downgrade|current|history}"
    echo ""
    echo "Commands:"
    echo "  init                     Initialize Alembic"
    echo "  generate <message>       Generate new migration"
    echo "  upgrade                  Upgrade to latest migration"
    echo "  downgrade                Downgrade by one revision"
    echo "  current                  Show current revision"
    echo "  history                  Show migration history"
    exit 1
fi