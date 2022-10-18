provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].external_v4_endpoint
    cluster_ca_certificate = yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["k8s", "create-token"]
      command     = "yc"
    }
  }
}

provider "kubernetes" {
  host                   = yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].external_v4_endpoint
  cluster_ca_certificate = yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["k8s", "create-token"]
    command     = "yc"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.2.1"
  wait       = true
  depends_on = [
    yandex_kubernetes_node_group.k8s_node_group
  ]
  set {
    name  = "controller.service.loadBalancerIP"
    value = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
}

resource "helm_release" "cert-manager" {
  namespace        = "cert-manager"
  create_namespace = true
  name             = "jetstack"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.9.1"
  wait             = true
  depends_on = [
    yandex_kubernetes_node_group.k8s_node_group
  ]
  set {
    name  = "installCRDs"
    value = true
  }
}

resource "local_file" "inventory_yml" {
  content = templatefile("ClusterIssuer.yaml.tpl",
    {
      email_letsencrypt = var.email_letsencrypt
    }
  )
  depends_on = [
    helm_release.cert-manager
  ]
  filename = "ClusterIssuer.yaml"
}

locals {
  jenkins_values_google_login = {
    "controller" = {
      "resources" = {
        "limits" = {
          "cpu"    = "2000m"
          "memory" = "3072Mi"
        }
      }
      "JCasC" = {
        "authorizationStrategy" = <<-EOT
        roleBased:
          roles:
            global:
              - name: "admin"
                description: "Jenkins administrators"
                permissions:
                  - "Overall/Administer"
                assignments:
                  - "admin@domain.com"
              - name: "tester"
                description: "Tester users"
                permissions:
                  - "Overall/Read"
                  - "Job/Build"
                  - "Job/Read"
                  - "Job/Workspace"
                assignments:
                  - "user1@domain.com"
        EOT
        "configScripts" = {
          "jenkins-configuration" = <<-EOT
          jenkins:
            systemMessage: This Jenkins is configured and managed 'as code' by Managed Cloud team.
          security:
            GlobalJobDslSecurityConfiguration:
              useScriptSecurity: false
          tool:
            allure:
              installations:
                - name: "allure"
                  properties:
                    - installSource:
                        installers:
                          - zip:
                              url: "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.18.1/allure-commandline-2.18.1.zip"
          credentials:
            system:
              domainCredentials:
                - credentials:
                    - string:
                        scope: GLOBAL
                        id: TOKEN
                        secret: "TOKEN"
          EOT
          job-config              = yamlencode({ jobs = [for _, job in local.jenkins_jobs : job] })
          views                   = local.views
        }
        "securityRealm" = <<-EOT
        googleOAuth2:
          clientId: "${var.clientId}"
          clientSecret: "${var.clientSecret}"
          domain: "${var.google_domain}"
        EOT
      }
      // Overwrite List of plugins to be install during Jenkins controller start
      "installPlugins" = [
        "kubernetes:3706.vdfb_d599579f3",
        "workflow-aggregator:590.v6a_d052e5a_a_b_5",
        "git:4.11.5",
        "configuration-as-code:1512.vb_79d418d5fc8",
      ]
      "additionalPlugins" = [
        "google-login:1.6",
        "job-dsl:1.81",
        "allure-jenkins-plugin:2.30.2",
        "ws-cleanup:0.43",
        "build-timeout:1.24",
        "timestamper:1.20",
        "google-storage-plugin:1.5.7",
        "permissive-script-security:0.7",
        "ansicolor:1.0.2",
        "google-oauth-plugin:1.0.7",
        "role-strategy:561.v9846c7351a_41",
        "build-name-setter:2.2.0",
        "uno-choice:2.6.4",
        "throttle-concurrents:2.9",
        "antisamy-markup-formatter:2.7",
      ]
      "imagePullPolicy" = "IfNotPresent"
      "ingress" = {
        "annotations" = {
          "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
        }
        "apiVersion"       = "networking.k8s.io/v1"
        "enabled"          = true
        "hostName"         = var.jenkins_dns_name
        "ingressClassName" = "nginx"
        "tls" = [
          {
            "hosts" = [
              var.jenkins_dns_name,
            ]
            "secretName" = "jenkins-tls"
          },
        ]
      }
      "javaOpts"                     = "-Dpermissive-script-security.enabled=true"
      "numExecutors"                 = 1
      "tag"                          = var.jenkins_version
      "adminPassword"                = "strongstrongpassword"
      "enableRawHtmlMarkupFormatter" = true
      "runAsUser"                    = 0
      "runAsGroup"                   = 0
      "containerSecurityContext" = {
        "runAsUser"              = 0
        "runAsGroup"             = 0
        "readOnlyRootFilesystem" = false
      }
      "lifecycle" = {
        "postStart" = {
          "exec" = {
            "command" = [
              "/bin/bash",
              "-c",
              "apt update && apt install -y jq",
            ]
          }
        }
      }
    }
    "agent" = {
      "resources" = {
        "requests" = {
          "cpu" = "100m"
        }
      }
    }
  }
}

resource "helm_release" "jenkins" {
  namespace        = "jenkins"
  create_namespace = true
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  wait             = true
  version          = "4.2.4"
  recreate_pods    = true
  values = [
    yamlencode(local.jenkins_values_google_login)
  ]
}
