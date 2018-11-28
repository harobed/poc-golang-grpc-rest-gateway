# Poc Golang gRPC with a REST Gateway

# Prerequisites

- Docker and docker-compose
- [httpie](https://httpie.org/) for manual test only

Prerequisites installation with [Brew](https://brew.sh/index_fr):

```sh
$ brew cask install docker httpie
```


# Run Echo demo

```
$ ./scripts/up.sh
$ ./scripts/enter.sh
# ./bin/echo-grpc-server
INFO[0000] Grpc server listen on :8080                   service=echo-grpc-server
INFO[0000] Json Rest server listen on :8081
INFO[0000] parsed scheme: ""                             service=echo-grpc-server system=system
INFO[0000] scheme "" not registered, fallback to default scheme  service=echo-grpc-server system=system
INFO[0000] ccResolverWrapper: sending new addresses to cc: [{:8080 0  <nil>}]  service=echo-grpc-server system=system
INFO[0000] ClientConn switching balancer to "pick_first"  service=echo-grpc-server system=system
INFO[0000] pickfirstBalancer: HandleSubConnStateChange: 0xc420134100, CONNECTING  service=echo-grpc-server system=system
INFO[0000] pickfirstBalancer: HandleSubConnStateChange: 0xc420134100, READY  service=echo-grpc-server system=system
```

# Test gRPC requests

In another terminal:

```
$ ./scripts/enter.sh
# echo '{"message": "foo"}' | evans --port 8080 --call Echo
{
  "message": "foo"
}
```


# Test Json Rest requests

```
$ source scripts/load-env.sh
$ echo '{"message": "Hello World"}' | http -v POST ${ECHO_JSON_REST}/echo
POST /echo HTTP/1.1
Accept: application/json, */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Content-Length: 27
Content-Type: application/json
Host: 0.0.0.0:32855
User-Agent: HTTPie/1.0.0

{
    "message": "Hello World"
}

HTTP/1.1 200 OK
Content-Length: 25
Content-Type: application/json
Date: Thu, 29 Nov 2018 13:13:49 GMT
Grpc-Metadata-Content-Type: application/grpc

{
    "message": "Hello World"
}
```
