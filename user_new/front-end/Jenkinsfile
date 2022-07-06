@Library('dynatrace@master') _

def tagMatchRules = [
  [
    meTypes: [
      [meType: 'SERVICE']
    ],
    tags : [
      [context: 'CONTEXTLESS', key: 'app', value: 'front-end'],
      [context: 'CONTEXTLESS', key: 'environment', value: 'dev']
    ]
  ]
]

pipeline {
  agent {
    label 'nodejs'
  }
  environment {
    APP_NAME = "front-end"
    ARTEFACT_ID = "sockshop/" + "${env.APP_NAME}"
    VERSION = readFile('version').trim()
    TAG = "${env.DOCKER_REGISTRY_URL}:5000/library/${env.ARTEFACT_ID}"
    TAG_DEV = "${env.TAG}-${env.VERSION}-${env.BUILD_NUMBER}"
    TAG_STAGING = "${env.TAG}-${env.VERSION}"
  }
  stages {
    stage('Node build') {
      steps {
        checkout scm
        container('nodejs') {
          sh 'npm install'
        }
      }
    }
    stage('Docker build') {
      when {
        expression {
          return env.BRANCH_NAME ==~ 'release/.*' || env.BRANCH_NAME ==~'master'
        }
      }
      steps {
        container('docker') {
          sh "docker build -t ${env.TAG_DEV} ."
        }
      }
    }
    stage('Docker push to registry') {
      when {
        expression {
          return env.BRANCH_NAME ==~ 'release/.*' || env.BRANCH_NAME ==~'master'
        }
      }
      steps {
        container('docker') {
          sh "docker push ${env.TAG_DEV}"
        }
      }
    }
    stage('Deploy to dev namespace') {
      when {
        expression {
          return env.BRANCH_NAME ==~ 'release/.*' || env.BRANCH_NAME ==~'master'
        }
      }
      steps {
        container('kubectl') {
          sh "sed -i 's#image: .*#image: ${env.TAG_DEV}#' manifest/front-end.yml"
          sh "kubectl -n dev apply -f manifest/front-end.yml"
        }
      }
    }
    stage('DT Deploy Event') {
      when {
          expression {
          return env.BRANCH_NAME ==~ 'release/.*' || env.BRANCH_NAME ==~'master'
          }
      }
      steps {
        container("curl") {
          script {
            def status = pushDynatraceDeploymentEvent (
              tagRule : tagMatchRules,
              customProperties : [
                [key: 'Jenkins Build Number', value: "${env.BUILD_ID}"],
                [key: 'Git commit', value: "${env.GIT_COMMIT}"]
              ]
            )
          }
        }
      }
    }
    stage('Mark artifact for staging namespace') {
      when {
        expression {
          return env.BRANCH_NAME ==~ 'release/.*'
        }
      }
      steps {
        container('docker'){
          sh "docker tag ${env.TAG_DEV} ${env.TAG_STAGING}"
          sh "docker push ${env.TAG_STAGING}"
        }
      }
    }
    stage('Deploy to staging') {
      when {
        beforeAgent true
        expression {
          return env.BRANCH_NAME ==~ 'release/.*'
        }
      }
      steps {
        build job: "k8s-deploy-staging",
          parameters: [
            string(name: 'APP_NAME', value: "${env.APP_NAME}"),
            string(name: 'TAG_STAGING', value: "${env.TAG_STAGING}"),
            string(name: 'VERSION', value: "${env.VERSION}")
          ]
      }
    }  
  }
}
