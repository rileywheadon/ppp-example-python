# PPP Example Python

This is a test service for my personal project platform (PPP).
It is a minimal Flask app built with Docker.
Using Docker Compose, the application can be run in development/production mode with a single command.

## Run in Development Mode

In development mode, we override some of the directives in the Dockerfile:

- The source code is mounted as a container volume to enable auto-reloading.
- Flask is run in debug mode using the development web server.

```bash
./scripts/dev.sh
```

## Run in Production Mode

In production mode, Flask is run with Gunicorn as described in the Dockerfile.

```bash
./scripts/build.sh
./scripts/deploy.sh
```
