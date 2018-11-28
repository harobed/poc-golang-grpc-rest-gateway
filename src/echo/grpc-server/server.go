package main

import (
	"fmt"
	"net"
	"net/http"
	"strings"

	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_logrus "github.com/grpc-ecosystem/go-grpc-middleware/logging/logrus"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"github.com/sirupsen/logrus"
	"golang.org/x/net/context"
	"google.golang.org/grpc"

	pb "echo/v1"
)

func listenAndServeGRPC(address string) error {
	logger_grcp := logrus.WithFields(logrus.Fields{
		"service": "echo-grpc-server",
	})
	logger_grcp.Info("Grpc server listen on ", address)

	grpcServer := grpc.NewServer(
		grpc_middleware.WithUnaryServerChain(
			grpc_logrus.UnaryServerInterceptor(logger_grcp),
		),
		grpc_middleware.WithStreamServerChain(
			grpc_logrus.StreamServerInterceptor(logger_grcp),
		),
	)
	s := Service{}
	pb.RegisterEchoServiceServer(grpcServer, &s)

	ln, err := net.Listen("tcp", address)
	if err != nil {
		logrus.Panicf("failed to listen: %v", err)
	}

	return grpcServer.Serve(ln)
}

func headerMatcher(headerName string) (string, bool) {
	return strings.ToLower(headerName), true
}

func listenAndServeREST(restAddress, grpcAddress string) error {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	mux := runtime.NewServeMux(runtime.WithIncomingHeaderMatcher(headerMatcher))

	opts := []grpc.DialOption{grpc.WithInsecure()}

	err := pb.RegisterEchoServiceHandlerFromEndpoint(
		ctx,
		mux,
		grpcAddress,
		opts,
	)
	if err != nil {
		return fmt.Errorf("could not register REST service: %s", err)
	}
	logrus.Info("Json Rest server listen on ", restAddress)

	return http.ListenAndServe(restAddress, mux)
}
