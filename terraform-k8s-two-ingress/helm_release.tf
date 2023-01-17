provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.twoingress_k8s_cluster.master[0].external_v4_endpoint
    cluster_ca_certificate = yandex_kubernetes_cluster.twoingress_k8s_cluster.master[0].cluster_ca_certificate
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
  version    = "4.4.2"
  wait       = true
  depends_on = [
    yandex_kubernetes_node_group.twoingress-k8s-node-group
  ]

}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "20.8.0"
  wait       = true
  depends_on = [
    yandex_kubernetes_node_group.twoingress-k8s-node-group
  ]

}
