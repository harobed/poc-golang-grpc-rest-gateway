#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

if [[ -f /.dockerenv ]]; then
  echo "You must execute $(basename $0) outside Docker container"
  exit 1
fi

docker build -f Dockerfile -t harobed/poc-golang-grpc-rest-gateway-goworkspace:develop .

echo "Don't forget to start ./scritps/up.sh to update current running workspace container"
