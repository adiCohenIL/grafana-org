# Use Go to build Dex
FROM golang:1.21-alpine AS builder
WORKDIR /app

# Clone Dex source
RUN apk add --no-cache git make gcc musl-dev sqlite-dev

ENV CGO_ENABLED=1

RUN git clone https://github.com/dexidp/dex.git .
RUN git checkout v2.38.0

ENV GOPROXY=direct GOSUMDB=off
# Build Dex for ARM64
RUN make build

# Create minimal runtime image
FROM alpine:3.18
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/dex /app/dex
COPY dex-config.yaml /app/dex-config.yaml
EXPOSE 5556
CMD ["/app/dex", "serve", "/app/config.yaml"]