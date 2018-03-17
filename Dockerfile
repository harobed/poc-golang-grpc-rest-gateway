FROM golang:1.9

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y bsdtar && \
    cd /usr/local/ && \
    curl -s -L https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip | bsdtar -xf- bin/protoc && \
    chmod u+x /usr/local/bin/protoc && \
    cd /usr/local/src/ && \
    curl -s -L https://github.com/google/protobuf/archive/v3.5.1.tar.gz | tar xvz && \
    cd /usr/local/bin/ && \
    curl -L -s https://github.com/go-task/task/releases/download/v2.0.0/task_linux_amd64.tar.gz | tar xz

RUN mkdir /code/
WORKDIR /code/
ENV GOPATH=/code/
ENV GOBIN=/usr/local/bin/

RUN go get -v -u github.com/golang/dep/cmd/dep && \
    go get -u github.com/golang/protobuf/protoc-gen-go && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway && \
    go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger



ENV GOBIN=/code/bin/
ENV PATH=/code/bin/:$PATH

COPY ./src/ /code/src/
COPY Taskfile.yml /code/
