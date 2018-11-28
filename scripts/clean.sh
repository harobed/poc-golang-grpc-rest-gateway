#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

rm -f src/echo/api/echo.pb.go
rm -f src/echo/api/echo.pb.gw.go
rm -f src/echo/api/echo.swagger.json
rm -rf src/echo/vendor
rm -rf pkg/
rm -f bin/echo
