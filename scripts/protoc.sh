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
  mkdir -p src/echo/v1
  protoc echo.proto \
    -I${GOPATH}/src/echo/protobuf/ \
    -I /usr/local/src/googleapis/ \
    -I /usr/local/src/protobuf/src/ \
    --grpc-gateway_out=logtostderr=true:src/ \
    --swagger_out=logtostderr=true:src/echo/v1 \
    --go_out=plugins=grpc:src/

  echo "src/echo/api/echo.pb.go generated"
  echo "src/echo/api/echo.pb.gw.go generated"
  echo "src/echo/api/echo.swagger.json generated"
fi
