FROM golang:1.18-alpine

WORKDIR /app/build

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /app/go-app . && \
    rm -rf /app/build

WORKDIR /app
EXPOSE 8080

CMD ["/app/go-app"]