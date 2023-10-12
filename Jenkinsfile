pipeline {
    agent any
        environment{
            REPOSITORY_NAME = "hrapp"
            AWS_REGION = credentials('AWS_REGION')
            ECR_REGISTRY = credentials('ECR_REGISTRY')
            AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')

        }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Pushing Image to ECR') {
            steps {
                echo 'Check Pushing Image to ECR'
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker build -t ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} .
                    docker tag ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ${ECR_REGISTRY}/${BRANCH_NAME}:${BUILD_NUMBER}
                    docker push ${ECR_REGISTRY}/${BRANCH_NAME}:${BUILD_NUMBER}
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
