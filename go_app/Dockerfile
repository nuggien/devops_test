# syntax=docker/dockerfile:1

FROM golang:1.16-alpine

WORKDIR /app

COPY go_app/go.mod ./
COPY go_app/go.sum ./
RUN go get github.com/prometheus/client_golang/prometheus/promhttp
RUN go mod download

COPY go_app/*.go ./

RUN go build -o /go-app
EXPOSE 8080

CMD [ "/go-app" ]