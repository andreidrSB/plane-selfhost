#!/bin/sh
set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="/backups/plane_db_${TIMESTAMP}.sql.gz"

echo "[$(date)] Starting backup → ${BACKUP_FILE}"

PGPASSWORD="${PGPASSWORD}" pg_dump \
  -h "${PGHOST}" \
  -p "${PGPORT}" \
  -U "${PGUSER}" \
  -d "${PGDATABASE}" \
  --no-password \
  | gzip > "${BACKUP_FILE}"

echo "[$(date)] Backup complete: $(du -sh "${BACKUP_FILE}" | cut -f1)"

# Prune old backups
find /backups -name "plane_db_*.sql.gz" \
  -mtime +"${BACKUP_RETENTION_DAYS:-14}" -delete

echo "[$(date)] Pruned backups older than ${BACKUP_RETENTION_DAYS:-14} days"
