resource "yandex_kubernetes_cluster" "zonal_k8s_cluster" {
  name        = "my-cluster"
  description = "my-cluster description"
  network_id  = yandex_vpc_network.k8s-network.id

  master {
    version = "1.21"
    zonal {
      zone      = yandex_vpc_subnet.k8s-subnet.zone
      subnet_id = yandex_vpc_subnet.k8s-subnet.id
    }
    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.sa-k8s-admin.id
  node_service_account_id = yandex_iam_service_account.sa-k8s-admin.id
  release_channel         = "STABLE"
  // to keep permissions of service account on destroy
  // until cluster will be destroyed
  depends_on = [yandex_resourcemanager_folder_iam_member.sa-k8s-admin-permissions]
}

# yandex_kubernetes_node_group

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = yandex_kubernetes_cluster.zonal_k8s_cluster.id
  name        = "name"
  description = "description"
  version     = "1.21"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.k8s-subnet.id]
    }

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 50
    }

    boot_disk {
      type = "network-hdd"
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
    server: ${yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].external_v4_endpoint}
    certificate-authority-data: ${base64encode(yandex_kubernetes_cluster.zonal_k8s_cluster.master[0].cluster_ca_certificate)}
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
