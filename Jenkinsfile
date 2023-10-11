pipeline {
    agent any
        environment{
            REPOSITORY_NAME = "hrapp"
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
                sh """
                docker build -t ${REPOSITORY_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} .
                """
                echo 'Build success'
            }
        }
        stage('Pushing Image to DockerHub') {
            steps {
                echo 'Check Pushing Image to DockerHub'
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
