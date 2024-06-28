FROM returntocorp/semgrep:latest
RUN apk update && \
    apk add --no-cache nodejs