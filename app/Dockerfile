FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s" -o api ./cmd/api

FROM gcr.io/distroless/static-debian12

WORKDIR /

COPY --from=builder /app/api /api

USER nonroot:nonroot

EXPOSE 8080

ENTRYPOINT ["/api"]
