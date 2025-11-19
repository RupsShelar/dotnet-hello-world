pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose Environment')
    }

    environment {
        DOCKERHUB_USER = credentials('rups1')
        DOCKERHUB_PASS = credentials('dckr_pat_TYDRmz42DkDl5SQ9G9JuZgsnj3c')
        UAT_HOST = "52.91.185.170"
        PROD_HOST = "44.212.77.93"
        IMAGE_NAME = "rups1/dotnetapp"
        TAG = "v1"
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
                sh "echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
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
                    if (params.ENV == 'UAT') {
                        sh "ssh -o StrictHostKeyChecking=no ${UAT_HOST} 'docker pull ${IMAGE_NAME}:${TAG} && docker run -d -p 5000:80 ${IMAGE_NAME}:${TAG}'"
                    } else {
                        sh "ssh -o StrictHostKeyChecking=no ${PROD_HOST} 'docker pull ${IMAGE_NAME}:${TAG} && docker run -d -p 5000:80 ${IMAGE_NAME}:${TAG}'"
                    }
                }
            }
        }
    }
}
