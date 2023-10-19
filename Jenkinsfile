pipeline {
    agent any
        environment{
            REPOSITORY_NAME = "hrapp"
            EC2_INSTANCE = "54.74.245.216"
            AWS_REGION = credentials('AWS_REGION')
            ECR_REGISTRY = credentials('ECR_REGISTRY')
            AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            SSH_KEY = credentials('SSH_KEY')
            POSTGRES_HOST = credentials('POSTGRES_HOST')
            POSTGRES_DATABASE_NAME = credentials('POSTGRES_DATABASE_NAME')
            POSTGRES_PASSWORD = credentials('POSTGRES_PASSWORD')
            POSTGRES_USER = credentials('POSTGRES_USER')

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
                """
            }
        }
        stage('Copy, push and start image to EC2 machine'){
            steps {
                echo 'Copying, pushing and starting image to && in EC2 machine'
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker pull ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BUILD_NUMBER}
                    docker save -o /tmp/${REPOSITORY_NAME}:${BUILD_NUMBER}.tar ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BUILD_NUMBER}
                    scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /tmp/${REPOSITORY_NAME}:${BUILD_NUMBER}.tar ec2-user@${EC2_INSTANCE}:~/path/to/destination
                    ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@${EC2_INSTANCE} 'docker load -i ~/path/to/destination/${REPOSITORY_NAME}:${BUILD_NUMBER}.tar'
                    ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@${EC2_INSTANCE} 'docker run -d -p 80:5000 -e POSTGRES_DATABASE_NAME=${POSTGRES_DATABASE_NAME} -e POSTGRES_HOST=${POSTGRES_HOST} -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -e POSTGRES_USER=${POSTGRES_USER} -e AWS_REGION_NAME=${AWS_REGION} -e AWS_ACCESS_NAME=${AWS_ACCESS_KEY_ID} -e AWS_KEY_NAME=${AWS_SECRET_ACCESS_KEY} ${ECR_REGISTRY}/${REPOSITORY_NAME}:${BUILD_NUMBER}'
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
