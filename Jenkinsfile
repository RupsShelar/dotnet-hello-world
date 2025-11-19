pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rups1/dotnetapp"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/RupsShelar/dotnet-hello-world.git', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE}:v1 .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    string(credentialsId: 'dockerhub-user', variable: 'DOCKERHUB_USER'),
                    string(credentialsId: 'dockerhub-pass', variable: 'DOCKERHUB_PASS')
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push ${DOCKER_IMAGE}:v1
                '''
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {

                    sh '''
                        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
                        aws configure set aws_secret_access_key "$AWS_SECRET_KEY"
                        aws configure set default.region ap-south-1

                        echo "Deploy docker container on EC2"
                       
                    '''
                }
            }
        }
    }
}
