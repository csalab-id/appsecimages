FROM ubuntu:22.04
WORKDIR /root
RUN apt update && \
    apt -y install curl wget unzip && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || true && \
    apt -f -y install && \
    useradd -m -c "Dast User" -s /bin/bash -d /home/dast dast && \
    wget -q https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip && \
    unzip -j chromedriver_linux64.zip chromedriver -d /usr/local/bin/ && \
    wget -q https://github.com/Arachni/arachni/releases/download/v1.6.1.3/arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz && \
    tar -xf arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz && \
    mv arachni-1.6.1.3-0.6.1.1/ /opt/arachni/ && \
    rm -rf google-chrome-stable_current_amd64.deb chromedriver_linux64.zip arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz
USER dast
WORKDIR /home/dast
ENTRYPOINT ["/opt/arachni/bin/arachni_web", "-o", "0.0.0.0"]