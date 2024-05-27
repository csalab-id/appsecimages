FROM sonarqube:9.9.1-community
COPY --chown=sonarqube:sonarqube sonarqube/ /home/sonarqube/sonarqube/
WORKDIR /home/sonarqube/sonarqube
ENTRYPOINT [ "bash", "/home/sonarqube/sonarqube/bin/linux-x86-64/sonar.sh", "console" ]