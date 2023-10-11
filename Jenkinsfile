pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Git') {
            steps {
                echo 'Git Clone'
                sh "git clone https://github.com/MrMacDit/weather-app.git"
                echo 'Cloned successfully'
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
