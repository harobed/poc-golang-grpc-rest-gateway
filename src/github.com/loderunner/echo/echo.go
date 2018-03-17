package main

import (
	"github.com/loderunner/echo/server"
)

func main() {
	grpcAddress := ":8080"
	restAddress := ":8081"
	go server.ListenAndServeREST(restAddress, grpcAddress)
	server.ListenAndServeGRPC(grpcAddress)
}
