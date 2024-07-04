FROM golang:1-alpine3.20 as builder
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
RUN apk add --no-cache git gcc musl-dev && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest

FROM python:3-alpine
LABEL maintainer="admin@csalab.id"
WORKDIR /root
RUN apk update && \
    apk -U upgrade --no-cache && \
    apk add --no-cache \
        jq \
        bind-tools \
        ca-certificates \
        chromium \
        git \
        nmap \
        nmap-scripts \
        perl \
        perl-net-ssleay && \
    git clone https://github.com/sqlmapproject/sqlmap /root/sqlmap && \
    git clone https://github.com/maurosoria/dirsearch /root/dirsearch && \
    git clone https://github.com/sullo/nikto /root/nikto && \
    wget -q https://github.com/shadow1ng/fscan/releases/download/1.8.4/fscan -O /usr/local/bin/fscan && \
    chmod +x /usr/local/bin/fscan && \
    wget -q https://github.com/epi052/feroxbuster/releases/download/v2.10.4/x86_64-linux-feroxbuster.tar.gz && \
    tar -xvf x86_64-linux-feroxbuster.tar.gz -C /usr/local/bin/ && \
    rm -rf x86_64-linux-feroxbuster.tar.gz && \
    chown root:root /usr/local/bin/feroxbuster && \
    chmod +x /usr/local/bin/feroxbuster && \
    mkdir -p /usr/share/seclists/Discovery/Web-Content/ && \
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt -O /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
COPY --chmod=0755 dast/xml2json.py /root/
COPY --from=builder --chown=root:root --chmod=0755 /go/bin/subfinder /usr/local/bin/
COPY --from=builder --chown=root:root --chmod=0755 /go/bin/httpx /usr/local/bin/
COPY --from=builder --chown=root:root --chmod=0755 /go/bin/nuclei /usr/local/bin/
COPY --from=builder --chown=root:root --chmod=0755 /go/bin/katana /usr/local/bin/
RUN pip install --upgrade pip && \
    pip install -r /root/dirsearch/requirements.txt && \
    pip install xmltodict && \
    /usr/local/bin/nuclei