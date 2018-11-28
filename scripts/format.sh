#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

if [ ! -f /.dockerenv ]; then
  if ! docker-compose ps -q goworkspace | wc -l | grep --quiet "1"; then
    echo "Error: you need to execute ./scrits/up.sh before execute $(basename $0)"
    exit 0
  fi
  docker-compose exec -T goworkspace scripts/$(basename $0)
else
  gofmt -w src/echo/grpc-server/
fi
