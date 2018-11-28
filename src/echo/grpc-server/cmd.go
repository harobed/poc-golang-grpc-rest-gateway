package main

func main() {
	grpcAddress := ":8080"
	restAddress := ":8081"

	go listenAndServeREST(restAddress, grpcAddress)
	listenAndServeGRPC(grpcAddress)
}
