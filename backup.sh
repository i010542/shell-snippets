#!/usr/bin/env bash
# backup.sh — Simple file backup with rotation
set -euo pipefail

SOURCE="${1:?Usage: backup.sh <source> <dest> [keep_count]}"
DEST="${2:?Usage: backup.sh <source> <dest> [keep_count]}"
KEEP="${3:-7}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="$(basename "$SOURCE")_$TIMESTAMP"

mkdir -p "$DEST"
cp -r "$SOURCE" "$DEST/$BACKUP_NAME"
echo "Backed up to: $DEST/$BACKUP_NAME"

# Rotate old backups
ls -dt "$DEST/$(basename "$SOURCE")"_* 2>/dev/null | tail -n +"$((KEEP + 1))" | xargs rm -rf
echo "Kept last $KEEP backups."
