data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_iam_service_account" "sa-compute-admin" {
  folder_id = var.yc_folder_id
  name      = "sa-compute-admin"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-compute-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-compute-admin.id}"
}

resource "yandex_compute_instance_group" "autoscaled-ig-with-coi" {
  name = "autoscaled-ig-with-coi"
  folder_id = var.yc_folder_id
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  instance_template {
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.container-optimized-image.id
      }
    }

    network_interface {
      network_id = data.yandex_vpc_network.default.id
      subnet_ids =[data.yandex_vpc_subnet.default-ru-central1-a.id]
      nat = true
    }

    metadata = {
      docker-container-declaration = file("${path.module}/declaration.yaml")
      user-data = file("${path.module}/cloud_config.yaml")
    }
    service_account_id = yandex_iam_service_account.sa-compute-admin.id
  }

  scale_policy {
    auto_scale {
      initial_size           = 3
      measurement_duration   = 60
      cpu_utilization_target = 75
      min_zone_size          = 3
      max_size               = 15
      warmup_duration        = 60
      stabilization_duration = 120
    }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating = 1
    max_expansion = 1
    max_deleting = 1
  }
}
