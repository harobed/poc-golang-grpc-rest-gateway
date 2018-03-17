package server

import (
	"golang.org/x/net/context"

	"github.com/loderunner/echo/api"
)

type Server struct{}

func (srv *Server) Echo(ctx context.Context, req *api.EchoRequest) (res *api.EchoResponse, err error) {
	res = &api.EchoResponse{
		Message: req.Message,
	}

	return res, nil
}
