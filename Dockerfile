FROM golang:latest as build

WORKDIR /build

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN go build -o /client 
 
FROM alpine:latest as run

COPY --from=build /client /client

CMD ["/client"]
