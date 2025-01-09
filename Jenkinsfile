pipeline {
  environment {
    DOCKER_IMAGE  = "pankajs2284/react-app"
    IMAGE_TAG = "${env.BUILD_ID}".replaceAll('[^a-zA-Z0-9._-]', '-') // Replace invalid characters
  }
  agent any
  stages {
    stage('Checkout Source') {
      steps {
        git branch: 'main', url: 'https://github.com/pankajsingh0684/jenkins-kubernetes-deployment.git'
      }
    }
    stage('Build image') {
      steps{
        script {
          bat "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
        }
      }
    }
    stage('Pushing Image') {
      steps{
        script {
		  withCredentials([usernamePassword(credentialsId: 'docker_hub', 
                              usernameVariable: 'DOCKER_USER', 
                              passwordVariable: 'DOCKER_PASS')]) {
          bat "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
          bat "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        
          }
        }
      }
    }

    stage('Deploying container to Kubernetes') {
      steps {
        script {
            def yamlContent = readFile('deployment.yaml')
            def updatedYamlContent = yamlContent.replaceAll(/image: .*/, "image: ${DOCKER_IMAGE}:${IMAGE_TAG}")
            writeFile(file: 'deployment.yaml', text: updatedYamlContent)
            bat '''
                 kubectl apply -f deployment.yaml
                 kubectl apply -f service.yaml
               '''
        }
      }
    }

  }

}

