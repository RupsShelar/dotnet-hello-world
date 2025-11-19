pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['UAT', 'PROD'], description: 'Choose Environment')
    }

    environment {
        DOCKERHUB_USER = credentials('dockerhub-user')
        DOCKERHUB_PASS = credentials('dockerhub-pass')

        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')

        UAT_HOST = "ec2-user@UAT_PUBLIC_IP"
        PROD_HOST = "ec2-user@PROD_PUBLIC_IP"
        IMAGE_NAME = "rups1/dotnetapp"
        TAG = "v1"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/RupsShelar/dotnet-hello-world.git'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                sh "echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${TAG}"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    HOST = (params.ENV == 'UAT') ? UAT_HOST : PROD_HOST

                    sh """
                    ssh -o StrictHostKeyChecking=no ${HOST} '
                        docker pull ${IMAGE_NAME}:${TAG} &&
                        docker stop dotnetapp || true &&
                        docker rm dotnetapp || true &&
                        docker run -d --name dotnetapp -p 5000:80 ${IMAGE_NAME}:${TAG}
                    '
                    """
                }
            }
        }
    }
}
