# Build stage
FROM golang:1.23-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server .

# Run stage
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=build /app/server .

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/app/server"]
