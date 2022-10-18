locals {
  jenkins_jobs = {
    job1 = {
      script = templatefile("template-job.tftpl",
        { name            = "job1",
          job_description = "",
        authenticationToken = "secret" }
      )
    }
  }
}