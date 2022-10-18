locals {
  views = <<-EOT
    jenkins:
      views:
        - all:
            name: "all"
        - list:
            columns:
            - "status"
            - "weather"
            - "jobName"
            - "lastSuccess"
            - "lastFailure"
            - "lastDuration"
            - "buildButton"
            jobNames:
            - "job1"
            name: "stage"
        - list:
            columns:
            - "status"
            - "weather"
            - "jobName"
            - "lastSuccess"
            - "lastFailure"
            - "lastDuration"
            - "buildButton"
            jobNames:
            - "job2"
            name: "test"
      viewsTabBar: "standard"
    EOT
}