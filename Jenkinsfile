pipeline {
    agent any
    
    stages {
        stage('build'){
            steps {
                echo 'running build'
            }
        }
        stage('test'){
            steps {
                echo 'running test'
            }
        }
        stage('integration test'){
            steps {
                echo 'running integration test'
            }
        }
    }
    post {
    always {
        echo 'I run always'
    }
    success {
        echo 'I run on success'
    }
    failure {
        echo 'I run on failure'
    }
}
}
