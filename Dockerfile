FROM golang:1.9

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y bsdtar tree

ENV GOPATH=/go/
ENV GOBIN=/usr/local/bin/

ENV PROTOBUF_VERSION=3.5.1
ENV GO_DEP_VERSIOR=0.5.0
ENV GOLANG_PROTOBUF_VERSION=v1.2.0
ENV GRPC_GATEWAY_VERSION=v1.5.1
ENV GOMETALINTER_VERSION=2.0.11

# Install protoc binary from https://github.com/protocolbuffers/protobuf
RUN cd /usr/local/ && \
    curl -s -L https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip | bsdtar -xf- bin/protoc && \
    chmod u+x /usr/local/bin/protoc

# Install Protobuf source from https://github.com/protocolbuffers/protobuf
RUN cd /usr/local/src/ && \
    curl -s -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz && \
    mv /usr/local/src/protobuf-${PROTOBUF_VERSION}/ /usr/local/src/protobuf/

# Install Public interface definitions of Google APIs. https://github.com/googleapis/googleapis/
RUN cd /usr/local/src/ && \
    curl -L -s https://github.com/googleapis/googleapis/archive/master.tar.gz | tar xvz && \
    mv /usr/local/src/googleapis-master/ /usr/local/src/googleapis/

# Install dep binary from https://github.com/golang/dep
RUN curl -s -L https://github.com/golang/dep/releases/download/v${GO_DEP_VERSIOR}/dep-linux-amd64 > /usr/local/bin/dep && \
    chmod u+x /usr/local/bin/dep

# Install Gox from https://github.com/mitchellh/gox
RUN go get github.com/mitchellh/gox

# Install Gometalinter binary from https://github.com/alecthomas/gometalinter
RUN cd /tmp/ && \
    curl -s -L https://github.com/alecthomas/gometalinter/releases/download/v${GOMETALINTER_VERSION}/gometalinter-${GOMETALINTER_VERSION}-linux-amd64.tar.gz | bsdtar -xf- && \
    mv gometalinter-${GOMETALINTER_VERSION}-linux-amd64/* /usr/local/bin/ && \
    rm -rf gometalinter-${GOMETALINTER_VERSION}-linux-amd64

# Install protoc-gen-go from https://github.com/golang/protobuf/
RUN go get -d -u github.com/golang/protobuf/protoc-gen-go && \
    git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout $GOLANG_PROTOBUF_VERSION && \
    go install github.com/golang/protobuf/protoc-gen-go

# Install protoc-gen-grpc-gateway from https://github.com/grpc-ecosystem/grpc-gateway
RUN curl -s -L https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v1.5.1/protoc-gen-grpc-gateway-${GRPC_GATEWAY_VERSION}-linux-x86_64 > /usr/local/bin/protoc-gen-grpc-gateway && \
    chmod u+x /usr/local/bin/protoc-gen-grpc-gateway

# Install protoc-gen-swagger from https://github.com/grpc-ecosystem/grpc-gateway
RUN curl -s -L https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v1.5.1/protoc-gen-swagger-${GRPC_GATEWAY_VERSION}-linux-x86_64 > /usr/local/bin/protoc-gen-swagger && \
    chmod u+x /usr/local/bin/protoc-gen-swagger

# Install evans from https://github.com/ktr0731/evans
RUN cd /usr/local/bin/ && \
    curl -s -L https://github.com/ktr0731/evans/releases/download/0.6.9/evans_linux_amd64.tar.gz | bsdtar -xf-

RUN mkdir /goworkspace/
WORKDIR /goworkspace/
ENV GOPATH=/goworkspace/
ENV GOBIN=/goworkspace/bin/
ENV PATH=/goworkspace/bin/:$PATH
