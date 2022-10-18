import javaposse.jobdsl.dsl.helpers.BuildParametersContext
class Params {
  protected static Closure context(@DelegatesTo(BuildParametersContext) Closure params) {
    params.resolveStrategy = Closure.DELEGATE_FIRST
    return params
  }

  static Closure extend(Closure params) {
    return context(params)
  }
}

def git_branch = "origin/awesomebranch"
def credential_id = "awesomerepocreds"
def jobs = [
        [
                name: "myjob",
                params: [
                        {
                          stringParam('ADDITIONAL_PARAM', 'default', 'description')
                        }
                ],
                repo: "https://github.com",
                directory: "dd",
                credential_id: "awesomerepocreds"
        ],
        [
                name: "myjob1",
                params: [
                        {
                          stringParam('ADDITIONAL_PARAM', 'default', 'description')
                        }
                ]
        ],
]

jobs.each { item ->
  pipelineJob(item.name) {
    // here go all the default parameters
    parameters {
      string {
        name('SOMEPARAM')
        defaultValue('')
        description('')
        trim(true)
      }
    }
    item.params.each { p ->
      parameters Params.extend(p)
    }

    definition {
      cpsScm {
        scm {
          git {
            branch('$branch')
            remote {
              url(item.repo)
              credentials(credential_id)
            }
          }
          scriptPath("jenkins/${item.directory}/Jenkinsfile")
        }
      }
    }
  }
}