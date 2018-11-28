#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

if [[ -f /.dockerenv ]]; then
  echo "You must execute $(basename $0) outside Docker container"
  exit 1
fi

docker push harobed/poc-golang-grpc-rest-gateway-goworkspace:develop
