#!/usr/bin/env bash
set -euo pipefail
BACKUP_FILE="${1:-}"
[[ -z "${BACKUP_FILE}" ]] && { echo "Usage: ./restore.sh <backup_file.sql.gz>"; exit 1; }

source .env

echo "WARNING: This will REPLACE the current Plane database."
read -rp "Type 'yes' to confirm: " CONFIRM
[[ "${CONFIRM}" != "yes" ]] && { echo "Aborted."; exit 0; }

echo "Stopping Plane app services..."
docker compose stop plane-api plane-worker plane-beat plane-web plane-live

echo "Dropping and recreating database..."
docker compose exec plane-db psql -U "${PGUSER}" postgres \
  -c "DROP DATABASE IF EXISTS ${PGDATABASE};" \
  -c "CREATE DATABASE ${PGDATABASE};"

echo "Restoring from ${BACKUP_FILE}..."
gunzip -c "${BACKUP_FILE}" | docker compose exec -T plane-db \
  psql -U "${PGUSER}" -d "${PGDATABASE}"

echo "Restarting services..."
docker compose up -d

echo "Restore complete."
