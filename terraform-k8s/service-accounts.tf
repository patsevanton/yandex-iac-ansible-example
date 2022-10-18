# SA k8s-cluster
resource "yandex_iam_service_account" "k8s-cluster" {
  folder_id = var.yc_folder_id
  name      = "k8s-cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-cluster-agent-permissions" {
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-publicAdmin-permissions" {
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-cluster.id}"
}

# SA k8s-node-group
resource "yandex_iam_service_account" "k8s-node-group" {
  folder_id = var.yc_folder_id
  name      = "k8s-node-group"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-node-group-permissions" {
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-node-group.id}"
}
