#!/usr/bin/env bash
set -euo pipefail
GREEN='\033[0;32m'; NC='\033[0m'
info() { echo -e "${GREEN}[UPGRADE]${NC} $*"; }

info "Pulling latest Plane images..."
docker compose pull

info "Stopping app services (infrastructure stays up)..."
docker compose stop plane-web plane-api plane-worker plane-beat plane-live plane-proxy

info "Running migrations..."
docker compose run --rm plane-migrator

info "Restarting app services..."
docker compose up -d plane-web plane-api plane-worker plane-beat plane-live plane-proxy

info "Upgrade complete. Running containers:"
docker compose ps
