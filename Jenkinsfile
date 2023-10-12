pipeline {
    agent any
        environment{
            REPOSITORY_NAME = "hrapp"
            EC2_INSTANCE = "63.32.60.34"
            AWS_REGION = credentials('AWS_REGION')
            ECR_REGISTRY = credentials('ECR_REGISTRY')
            AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            SSH_KEY = credentials('SSH_KEY')

        }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Create and push image to ECR and EC2') {
            steps {
                echo 'Check Pushing Image to ECR'
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker build -t ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} .
                    docker tag ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BUILD_NUMBER}
                    docker push ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BUILD_NUMBER}
                    scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ec2-user@${EC2_INSTANCE}:/path/to/destination
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
