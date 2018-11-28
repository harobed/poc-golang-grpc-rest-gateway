export ECHO_JSON_REST=http://$(docker-compose port goworkspace 8081)
export ECHO_GRPC_HOST=127.0.0.1
export ECHO_GRPC_PORT=$(docker-compose port goworkspace 8080 | sed 's/.*\://')
