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
      "JCasC" = {
        "authorizationStrategy" = <<-EOT
        loggedInUsersCanDoAnything:
          allowAnonymousRead: false
        EOT
        "configScripts" = {
          "jenkins-configuration" = <<-EOT
          jenkins:
            systemMessage: This Jenkins is configured and managed 'as code' by Managed Cloud team.
          security:
            globaljobdslsecurityconfiguration:
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

#          credentials:
#            system:
#              domainCredentials:
#                - credentials:
#                    - googleRobotPrivateKey:
#                        projectId: 'test-project'
#                        serviceAccountConfig:
#                          json:
#                            # The contents of test-key.json in base64
#                            secretJsonKey: 'xxxx'
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
      "additionalPlugins" = [
        "google-login:1.6",
        "job-dsl:1.81",
        "allure-jenkins-plugin:2.30.2",
        "ws-cleanup:0.42",
        "build-timeout:1.21",
        "timestamper:1.18",
        "google-storage-plugin:1.5.6",
        "permissive-script-security:0.7",
        "ansicolor:1.0.2",
        "google-oauth-plugin:1.0.6",
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
      "javaOpts"     = "-Dpermissive-script-security.enabled=true"
      "numExecutors" = 0
      "tag"          = var.jenkins_version
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
  version          = "4.1.17"
  depends_on = [
    yandex_kubernetes_node_group.k8s_node_group
  ]
  values = [
    #file("${path.module}/jenkins-values-google-login.yaml")
    yamlencode(local.jenkins_values_google_login)
  ]
}
