#!/bin/bash

cd "$(dirname "$0")/../"

if [[ -f /.dockerenv ]]; then
  echo "You must execute $(basename $0) outside Docker container"
  exit 1
fi
if ! docker-compose ps -q goworkspace | wc -l | grep --quiet "1"; then
  echo "Error: you need to execute ./scrits/up.sh before execute $(basename $0)"
  exit 1
fi

docker-compose exec goworkspace bash
