#!/usr/bin/env bash
set -e

HOST=${1:-localhost}
PORT=${2:-80}
URL="http://${HOST}:${PORT}/"

echo "Waiting for app at $URL…"
for i in {1..10}; do
  if curl --fail --silent "$URL"; then
    echo "✅ App responded successfully!"
    exit 0
  fi
  sleep 1
done

echo "❌ App did not respond at $URL"
exit 1
