FROM golang:1.22.5 as base

WORKDIR /app

COPY go.mod .  
RUN go mod download

# Copy the remaining source code
COPY . .

# Build the Go binary
RUN go build -o main .

# Final stage - Distroless image
FROM gcr.io/distroless/base

# Copy the binary from the base stage
COPY --from=base /app/main .

# Copy any necessary static files
COPY --from=base /app/static ./static

EXPOSE 8080

# Run the Go binary
CMD ["./main"]
