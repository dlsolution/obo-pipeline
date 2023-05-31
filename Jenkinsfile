pipeline {
  agent any
  environment {
    DOCKER_REGISTRY_USERNAME = credentials('DOCKER_REGISTRY_USERNAME')
    DOCKER_REGISTRY_PASSWORD = credentials('DOCKER_REGISTRY_PASSWORD')
  }

  stages {
    stage('Build') {
      steps {
        sh '''
          echo "Starting to build docker image"
          docker build -t duylinh158/obo-pipeline:v1.${BUILD_NUMBER} -f Dockerfile .
        '''
        sh '''
          echo "Starting to push docker image"
          echo ${DOCKER_REGISTRY_PASSWORD} | docker login -u ${DOCKER_REGISTRY_USERNAME} --password-stdin
          docker push duylinh158/obo-pipeline:v1.${BUILD_NUMBER}
        '''
      }
    }
    stage('Deploy') {
      steps {
        script {
          sh "echo 'Deploy to kubernetes'"
          def filename = 'manifests/deployment.yaml'
          def data = readYaml file: filename
          data.spec.template.spec.containers[0].image = "duylinh158/obo-pipeline:v1.${BUILD_NUMBER}"
          sh "rm $filename"
          writeYaml file: filename, data: data
          sh "cat $filename"
        }
        withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://192.168.1.4:6443']) {
          sh 'kubectl apply -f manifests'
        }
      }
    }
  }
}
