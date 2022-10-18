locals {
  jenkins_jobs = {
    job1 = {
      script = <<-EOT
        pipelineJob('job1') {
          logRotator(120, -1, 1, -1)
          authenticationToken('secret')
          definition {
            cps {
              script("""\
                pipeline {
                  agent any
                  parameters {
                      string(name: 'Variable', defaultValue: '', description: 'Variable', trim: true)
                  }
                  options {
                    timestamps()
                    ansiColor('xterm')  
                    timeout(time: 10, unit: 'MINUTES')
                  }
                  stages {
                    stage ('build') {
                      steps {
                        cleanWs()
                        sh '''#!/bin/bash
                              cat /etc/*release*
                              curl --version || true
                              if [ -d "/path/to/dir" ]
                              then
                                  echo "Directory /path/to/dir exists."
                              else
                                  echo "Error: Directory /path/to/dir does not exists."
                              fi
                        '''
                      }
                    }
                  }
                  post {
                    always {
                      allure includeProperties: false, jdk: '', results: [[path: 'target/allure-results']]
                      }
                    }
                }""".stripIndent())
              sandbox()
            }
          }
        }
      EOT
    }
    job2 = {
      script = <<-EOT
        pipelineJob('job2') {
          logRotator(120, -1, 1, -1)
          authenticationToken('secret')
          definition {
            cps {
              script("""\
                pipeline {
                  agent any
                  parameters {
                      string(name: 'Variable', defaultValue: '', description: 'Variable', trim: true)
                  }
                  options {
                    timestamps()
                    ansiColor('xterm')  
                    timeout(time: 10, unit: 'MINUTES')
                  }
                  stages {
                    stage ('build') {
                      steps {
                        cleanWs()
                        echo "hello job1"
                      }
                    }
                  }
                }""".stripIndent())
              sandbox()
            }
          }
        }
      EOT
    }
  }
}