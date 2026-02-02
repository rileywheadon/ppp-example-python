# PPP Example Python

This is a test service for my personal project platform (PPP).
It is a minimal Flask app built with Docker.
Using Docker Compose, the application can be run in development/production mode with a single command.

## Scripts

All scripts are in `scripts/`. 
Ensure they are executable (`chmod +x scripts/*.sh`) before use.

### `scripts/config.sh`

Contains non-secret environment variables for the application.
You should not need to run this script manually.

### `scripts/build.sh`

Builds Docker images (tagged by `version.yaml` and `latest`) and pushes them to Docker Hub.

### `scripts/deploy.sh [domain]`

Deploys the service on the host by bringing up the database, running migrations, then starting the application containers via Docker Compose.
Requires a Docker image in Docker Hub with the version defined in `version.yaml`.

### `scripts/dev.sh`

Starts the development compose stack (`docker-compose.dev.yaml`), runs migrations, and starts the app in dev mode.

### `scripts/migrate.sh <command> [message]`

Run Alembic commands inside the application container (`init|generate|upgrade|downgrade|current|history`).
For example, `./scripts/migrate.sh upgrade` (upgrade), `./scripts/migrate.sh generate "add users table"` (generate an empty migration).

### `scripts/test.sh`

Runs the test compose stack, executes tests inside the test container, and cleans up test containers afterwards.

## Droplet Prerequisites (for `deploy.yaml` GitHub Action)

Minimal items to prepare on the DigitalOcean droplet so the workflow can SSH and run `./scripts/deploy.sh`:

User and SSH:

- Create a `deploy` user and add your CI SSH public key to `/home/deploy/.ssh/authorized_keys`.
- Ensure the GitHub Actions secret SSH key matches the `deploy` user's private key.

Directory and Repository:

- The repository is located at the path: `/home/deploy/ppp-example-python/` 
- Ensure the repo is owned by `deploy`: `chown -R deploy:deploy /home/deploy/ppp-example-python`
- Ensure scripts are executable: `chmod +x /home/deploy/ppp-example-python/scripts/*.sh`

Software:

- Install Docker Engine and the Docker Compose plugin.
- Install Git (so the workflow's `git pull` works).
- Enable and start Docker: `systemctl enable --now docker`.

Permissions and Groups:

- Add `deploy` to the `docker` group so the user can run Docker without sudo: `usermod -aG docker deploy`.