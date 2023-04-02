provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.loki_k8s_cluster.master[0].external_v4_endpoint
    cluster_ca_certificate = yandex_kubernetes_cluster.loki_k8s_cluster.master[0].cluster_ca_certificate
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
  version    = "4.6.0"
  wait       = true
  depends_on = [
    yandex_kubernetes_node_group.loki-k8s-node-group
  ]

  set {
    name  = "controller.service.loadBalancerIP"
    value = yandex_vpc_address.promgrafana_address.external_ipv4_address[0].address
  }

  set {
    name  = "controller.config.log-format-escape-json"
    value = true
  }

  set {
    name  = "controller.config.log-format-upstream"
    value = "{\"time\": \"$time_iso8601\", \"remote_addr\": \"$proxy_protocol_addr\"}"
  }

}

