pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose Environment')
    }

    environment {

        // DockerHub credentials
        DOCKER_CREDS = credentials('dockerhub-creds')

        // AWS credentials
        AWS_CREDS = credentials('aws-creds')

        IMAGE_NAME = "rups1/dotnetapp"
        TAG = "v1"

        UAT_HOST = "ec2-user@UAT_PUBLIC_IP"
        PROD_HOST = "ec2-user@PROD_PUBLIC_IP"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git 'https://github.com/RupsShelar/dotnet-hello-world.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${TAG}"
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    def HOST = (params.ENV == 'UAT') ? UAT_HOST : PROD_HOST

                    sh """
                        ssh -o StrictHostKeyChecking=no ${HOST} '
                            docker pull ${IMAGE_NAME}:${TAG} &&
                            docker stop app || true &&
                            docker rm app || true &&
                            docker run -d --name app -p 5000:80 ${IMAGE_NAME}:${TAG}
                        '
                    """
                }
            }
        }
    }
}
