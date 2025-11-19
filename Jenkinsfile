pipeline {
    agent any

    environment {
        DOCKERHUB_USER   = credentials('dockerhub-user')
        DOCKERHUB_PASS   = credentials('dockerhub-pass')
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/RupsShelar/dotnet-hello-world.git', branch: 'master'
            }
        }

        stage('Build Image') {
            steps {
                sh """
                  docker build -t ${DOCKERHUB_USER}/dotnetapp:v1 .
                """
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                  echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                """
            }
        }

        stage('Push Image') {
            steps {
                sh """
                  docker push ${DOCKERHUB_USER}/dotnetapp:v1
                """
            }
        }

        stage('Deploy') {
            steps {
                sh "echo Deploying..."
            }
        }
    }
}
