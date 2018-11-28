package main

import (
	pb "echo/v1"

	"golang.org/x/net/context"
)

type Service struct{}

func (srv *Service) Echo(ctx context.Context, req *pb.EchoRequest) (res *pb.EchoResponse, err error) {
	res = &pb.EchoResponse{
		Message: req.Message,
	}

	return res, nil
}
