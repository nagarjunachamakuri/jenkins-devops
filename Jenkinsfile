pipeline {
    
    environment {
        email = credentials('azureusername')
        password = credentials('azurepassword')
        
    
    }
    
    agent any
    tools {
  terraform 'myTerraform'
    }

    
    
    stages {
        stage('GIT checkout') {
            steps{
                 
                 git branch: 'main', url: 'https://github.com/nagarjunachamakuri/jenkins-devops'
            }
           
        }
        stage('INIT'){
            steps {
                sh 'terraform init'
            }
            
        }
    }
}
