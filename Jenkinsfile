pipeline {
    agent any

    tools { 
        jdk 'JDK17' 
    }

    environment {  
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        DOCKER_TAG = getVersion()
    }

    stages {

        stage ('Clone Stage') { 
            steps { 
                git branch: 'main', url: 'https://github.com/nourbenothmen/pipeline-project.git'
            } 
        }

        stage ('Docker Build') { 
            steps { 
                sh 'docker build -t nourelhouabenothmen0/aston-villa:${DOCKER_TAG} .'
            } 
        }         

        stage ('DockerHub Push') { 
            steps { 
                withCredentials([string(credentialsId: 'mydockerhubpassword', variable: 'DockerHubPassword')]) { 
                    sh 'docker login -u nourelhouabenothmen0@gmail.com -p ${DockerHubPassword}'
                }
                sh 'docker push nourelhouabenothmen0/aston-villa:${DOCKER_TAG}'
            } 
        }         

        stage ('Deploy') { 
            steps { 
                sshagent(credentials: ['Vagrant_ssh']) { 
                    sh "ssh user@master 'docker pull nourelhouabenothmen0/aston-villa:${DOCKER_TAG}'"
                    sh "ssh user@master 'docker stop angular-app || true && docker rm angular-app || true'"
                    sh "ssh user@master 'docker run -d --name angular-app -p 80:80 nourelhouabenothmen0/aston-villa:${DOCKER_TAG}'"
                }     
            } 
        }
    }
}

def getVersion() { 
    return sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
}
