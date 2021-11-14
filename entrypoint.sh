#!/usr/bin/env bash

# entrypoint is set in docker-compose file which describes multicontainer environment while referencing the Dockerfile.

# use gunicorn in production
gunicorn --bind 0.0.0.0:${APP_PORT} run:app

# use flask cli for development
# flask run --host 0.0.0.0 --port ${APP_PORT}