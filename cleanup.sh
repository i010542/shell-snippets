#!/usr/bin/env bash
# cleanup.sh — Disk space cleanup utilities
set -euo pipefail

# Remove Docker unused resources
clean_docker() {
  echo "Cleaning Docker resources..."
  docker system prune -f --volumes
  docker image prune -a -f
  echo "Docker cleanup complete."
}

# Remove old log files (older than N days)
clean_logs() {
  local log_dir="${1:-/var/log}"
  local days="${2:-30}"
  echo "Removing logs older than $days days in $log_dir..."
  find "$log_dir" -type f -name "*.log" -mtime +"$days" -delete
  echo "Log cleanup complete."
}

# Remove temp files
clean_tmp() {
  echo "Cleaning temp files..."
  find /tmp -type f -mtime +3 -delete 2>/dev/null || true
  echo "Temp cleanup complete."
}

case "${1:-all}" in
  docker) clean_docker ;;
  logs)   clean_logs "${2:-/var/log}" "${3:-30}" ;;
  tmp)    clean_tmp ;;
  all)    clean_docker; clean_logs; clean_tmp ;;
  *)      echo "Usage: cleanup.sh [docker|logs|tmp|all]"; exit 1 ;;
esac
