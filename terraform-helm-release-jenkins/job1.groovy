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
                echo "hello job1"
              }
            }
          }
        }""".stripIndent())
      sandbox()
    }
  }
}