pipeline {
    agent {
        label "master"
    }
    tools {
        maven "for-guacamole-build"
    }

    environment {
        //AWS_CRED     = credentials('AWS_CREDENTIALS')
        
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "localhost:8081"
        NEXUS_REPOSITORY = "api-gateway-releases"
        NEXUS_CREDENTIAL_ID = "nexus-credentials"
    }

    stages {
        stage("Clone code from VCS") {
            steps {
                script {
                    git branch: 'main', 
                    credentialsId: 'github-ssh-key', 
                    url: 'git@github.com:armhov/epam-final-task.git'
                }
            }
        }

        stage("Maven Build") {
            steps {
                script {
                    sh "mvn clean package -DskipTests=true"
                }
            }
        }
        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    nexusArtifactUploader artifacts: [[artifactId: 'java-api', classifier: '', file: '/var/lib/jenkins/workspace/api-gateway-test/target/api-gateway.jar', type: 'jar']], credentialsId: 'nexus-credentials', 
                    groupId: 'api-gateway',
                    nexusUrl: 'localhost:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: 'api-gateway-releases',
                    version: '$BUILD_NUMBER'
                }
            }
        }

        stage("========Run packer=======") {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script{
                        sh 'cd packer/ && ls -la'
                        sh 'cd packer/ && packer build ubuntu_ami.json'
                    }
                }   
            }
        }
        stage('====Terraform init======') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'echo $AWS_ACCESS_KEY_ID'
                    sh 'cd terraform/ && ls -la'
                    sh 'cd terraform/ && terraform init -input=false'
                    sh "cd terraform/ && terraform plan -input=false -out tfplan "
                }
            }
        }
   }
}