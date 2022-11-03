resource "yandex_kubernetes_cluster" "loki_k8s_cluster" {
  name        = "loki-cluster"
  description = "loki-cluster description"
  network_id  = data.yandex_vpc_network.default.id

  master {
    version = "1.22"
    zonal {
      zone      = data.yandex_vpc_subnet.default-ru-central1-a.zone
      subnet_id = data.yandex_vpc_subnet.default-ru-central1-a.id
    }
    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.loki-k8s-cluster.id
  node_service_account_id = yandex_iam_service_account.loki-k8s-node-group.id
  release_channel         = "STABLE"
  // to keep permissions of service account on destroy
  // until cluster will be destroyed
  depends_on = [
    yandex_resourcemanager_folder_iam_member.loki-k8s-cluster-agent-permissions,
    yandex_resourcemanager_folder_iam_member.loki-vpc-publicAdmin-permissions,
    yandex_resourcemanager_folder_iam_member.loki-load-balancer-admin-permissions,
    yandex_resourcemanager_folder_iam_member.loki-k8s-node-group-permissions,
  ]
}

# yandex_kubernetes_node_group

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = yandex_kubernetes_cluster.loki_k8s_cluster.id
  name        = "name"
  description = "description"
  version     = "1.22"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = [data.yandex_vpc_subnet.default-ru-central1-a.id]
    }

    resources {
      memory        = 4
      cores         = 16
      core_fraction = 50
    }

    boot_disk {
      type = "network-ssd"
      size = 32
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }

  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}



locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${yandex_kubernetes_cluster.loki_k8s_cluster.master[0].external_v4_endpoint}
    certificate-authority-data: ${base64encode(yandex_kubernetes_cluster.loki_k8s_cluster.master[0].cluster_ca_certificate)}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: yc
  name: ycmk8s
current-context: ycmk8s
users:
- name: yc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: yc
      args:
      - k8s
      - create-token
KUBECONFIG
}

output "kubeconfig" {
  value = local.kubeconfig
}
