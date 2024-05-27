pipeline {
    agent none
    stages {
        stage('Nmap') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'nmap -Pn -sV -p 1-65535 ${TARGET} --script vuln -oX nmap.xml'
                }
            }
            post {
                success {
                    archiveArtifacts 'nmap.xml'
                }
            }
        }
        stage('Nuclei') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh '/root/go/bin/nuclei -u ${URL_TARGET} -nc -je nuclei.json'
                    sh '/root/go/bin/nuclei -u ${URL_TARGET} -nc -as -je nuclei-as.json'
                }
            }
            post {
                success {
                    archiveArtifacts 'nuclei.json'
                    archiveArtifacts 'nuclei-as.json'
                }
            }
        }
        stage('Zaproxy') {
            agent {
                docker {
                    image 'owasp/zap2docker-stable:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'zap-baseline.py -I -j -t ${URL_TARGET}'
                }
            }
        }
        stage('Dirsearch') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh '/root/dirsearch/dirsearch.py -u ${URL_TARGET} -e php -o dirsearch.json --format=json -q'
                }
            }
            post {
                success {
                    archiveArtifacts 'dirsearch.json'
                }
            }
        }
        stage('Nikto') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh '/root/nikto/program/nikto.pl -h ${URL_TARGET} -C all -o nikto.json || true'
                }
            }
            post {
                success {
                    archiveArtifacts 'nikto.json'
                }
            }
        }
        stage('Sqlmap') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh '/root/sqlmap/sqlmap.py -u ${URL_TARGET} --form --random-agent --batch --crawl=10 --dbs'
                }
            }
        }
        stage('Generate report') {
            agent {
                docker {
                    image 'csalab/dast-ci:latest'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'echo "Generating report"'
                    sh 'python3 /root/xml2json.py nmap.xml nmap.json'
                    sh 'ls -l *.json'
                    sh 'rm -rf *.xml *.json reports'
                }
            }
        }
    }
}
