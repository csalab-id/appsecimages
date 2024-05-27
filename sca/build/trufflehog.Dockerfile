FROM trufflesecurity/trufflehog:latest
RUN apk update && \
    apk add nodejs