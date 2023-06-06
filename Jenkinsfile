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
          docker push "duylinh158/obo-pipeline:v1.${BUILD_NUMBER}"
        '''
      }
    }

    stage('Deploy') {
      steps {
        withCredentials([gitUsernamePassword(credentialsId: 'jenkins_github_pac', gitToolName: 'Default')]) {
          sh 'rm -rf obo-app-with-helm'
          sh 'git clone https://github.com/dlsolution/obo-app-with-helm.git'
        }
        script {
          sh "echo 'Update values manifest'"
          def filename = 'obo-app-with-helm/values.yaml'
          def data = readYaml file: filename
          data.image.tag = "v1.${BUILD_NUMBER}"
          data.env.secret.database_url = "jdbc:mysql://192.168.1.6:3336/obo?useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"
          sh "rm $filename"
          writeYaml file: filename, data: data
          sh "cat $filename"
        }
        withCredentials([gitUsernamePassword(credentialsId: 'jenkins_github_pac', gitToolName: 'Default')]) {
          sh '''
            cd obo-app-with-helm
            git config user.email "jenkins@example.com"
            git config user.name "Jenkins"
            git add values.yaml
            git commit -am "update image to tag v1.${BUILD_NUMBER}"
            git push origin master
          '''
        }
      }
    }
  }
}