# Poc Golang gRPC with a REST Gateway

Based on [loderunner/boilr-grpc](https://github.com/loderunner/boilr-grpc)

# Prerequisites

* Docker and docker-compose
* [task](https://github.com/go-task/task) - A task runner / simpler Make alternative written in Go

Prerequisites installation with [Brew](https://brew.sh/index_fr):

```
$ brew tap go-task/tap
$ brew install go-task
$ brew cask install docker
```

# Run Echo demo

```
$ task init
$ task enter
# ./echo
```

# Use with Rest

```
$ echo '{"message": "Hello World"}' | http -v POST http://`docker-compose port app 8081`/echo
POST /echo HTTP/1.1
Accept: application/json, */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Content-Length: 27
Content-Type: application/json
Host: 0.0.0.0:32772
User-Agent: HTTPie/0.9.9

{
    "message": "Hello World"
}

HTTP/1.1 200 OK
Content-Length: 25
Content-Type: application/json
Date: Sat, 17 Mar 2018 21:15:17 GMT
Grpc-Metadata-Content-Type: application/grpc

{
    "message": "Hello World"
}
```


# Use gRPC with [evans](https://github.com/ktr0731/evans):

REPL mode:

```
$ evans --host 127.0.0.1 \
  --port `docker-compose port app 8080 | sed 's/.*\://'` \
  src/github.com/loderunner/echo/api/echo.proto

  ______
 |  ____|
 | |__    __   __   __ _   _ __    ___
 |  __|   \ \ / /  / _. | | '_ \  / __|
 | |____   \ V /  | (_| | | | | | \__ \
 |______|   \_/    \__,_| |_| |_| |___/

 more expressive universal gRPC client


127.0.0.1:32773> package api

api@127.0.0.1:32773> service Echo

api.Echo@127.0.0.1:32773> call Echo
message (TYPE_STRING) => foobar
{
  "message": "foobar"
}
```

Command-line mode:

```
$ echo '{"message": "foo"}' | evans \
  --host 127.0.0.1 \
  --port `docker-compose port app 8080 | sed 's/.*\://'` src/github.com/loderunner/echo/api/echo.proto \
  --package api \
  --service Echo \
  --call Echo
```
