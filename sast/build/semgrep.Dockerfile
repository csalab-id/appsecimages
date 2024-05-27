FROM returntocorp/semgrep:latest
RUN apk update && \
    apk add nodejs