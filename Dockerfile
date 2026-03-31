# Use the official builder image
FROM caddy:builder-alpine AS builder

# Build Caddy with your required plugins
RUN xcaddy build \
    --with github.com/caddy-dns/desec \
    --with github.com/hslatman/caddy-crowdsec-bouncer

# Use the standard Caddy alpine image for the final run
FROM caddy:alpine

# Copy the custom binary from the builder
COPY --from=builder /usr/bin/caddy /usr/bin/caddy