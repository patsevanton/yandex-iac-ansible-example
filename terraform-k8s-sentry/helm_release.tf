provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.sentry_k8s_cluster.master[0].external_v4_endpoint
    cluster_ca_certificate = yandex_kubernetes_cluster.sentry_k8s_cluster.master[0].cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["k8s", "create-token"]
      command     = "yc"
    }
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.0"
  wait       = true
  depends_on = [
    yandex_kubernetes_node_group.sentry-k8s-node-group
  ]

  set {
    name  = "controller.service.loadBalancerIP"
    value = yandex_vpc_address.sentry_address.external_ipv4_address[0].address
  }
}


resource "local_file" "inventory_yml" {
  content = templatefile("ClusterIssuer.yaml.tpl",
    {
      email_letsencrypt = var.email_letsencrypt
    }
  )
  filename = "ClusterIssuer.yaml"
}
