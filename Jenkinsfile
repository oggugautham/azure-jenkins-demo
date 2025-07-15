pipeline {
  agent any
  environment {
    ARM_SUBSCRIPTION_ID = credentials('az-sub-id')
    ARM_CLIENT_ID       = credentials('az-client-id')
    ARM_CLIENT_SECRET   = credentials('az-client-secret')
    ARM_TENANT_ID       = credentials('az-tenant-id')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Init') {
      steps { sh 'terraform -chdir=infra init' }
    }
    stage('Validate') {
      steps { sh 'terraform -chdir=infra validate' }
    }
    stage('Plan') {
      steps { sh 'terraform -chdir=infra plan -out=tfplan' }
    }
    stage('Apply') {
      steps { sh 'terraform -chdir=infra apply -auto-approve tfplan' }
    }
    stage('Sonar Scan') {
      steps {
        withSonarQubeEnv('SonarDemo') {
            sh """
                sonar-scanner \
                -Dsonar.projectKey=azure-jenkins-demo \
                -Dsonar.sources=infra \
                -Dsonar.host.url=http://sonar-1813.canadacentral.azurecontainer.io:9000
            """
        }
      }
    }
    stage('Destroy') {
      when { expression { return params.DESTROY == 'true' } }
      steps { sh 'terraform -chdir=infra destroy -auto-approve' }
    }
  }
}