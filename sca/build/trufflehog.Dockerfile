FROM trufflesecurity/trufflehog:latest
RUN apk update && \
    apk add --no-cache nodejs