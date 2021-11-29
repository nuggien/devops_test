# syntax=docker/dockerfile:1

FROM golang:1.16-alpine

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go get github.com/prometheus/client_golang/prometheus/promhttp
RUN go mod download

COPY *.go ./

RUN go build -o /go-app
EXPOSE 8080

CMD [ "/go-app" ]