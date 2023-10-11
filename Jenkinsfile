pipeline {
    agent any
        environment{
            REPOSITORY_NAME = "hrapp"
            AWS_REGION = "eu-west-1"
            ECR_REGISTRY = credentials('ECR_REGISTRY')
        }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Building Docker Image') {
            steps {
                echo 'Shout out to the creation of our docker image'
                sh "docker build -t ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ."
            }
        }
        stage('Pushing Image to ECR') {
            steps {
                echo 'Check Pushing Image to DockerHub'
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                echo 'Tagging image'
                sh """
                    docker tag ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER}
                    docker push ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER}
                """
            }
        }
    } 
    post {
        always {
            echo 'Always Post'
            deleteDir()
        }
    }
}
