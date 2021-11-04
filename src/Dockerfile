FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY main.go ./

RUN go build -o /main-app


FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /main-app /main-app

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/main-app"]