data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

locals {
  vhost_ip_map = {
    "consul.apatsev.org.ru"  = yandex_vpc_address.consul_address.external_ipv4_address[0].address
    "grafana.apatsev.org.ru" = yandex_vpc_address.grafana_address.external_ipv4_address[0].address
  }
}

data "cloudinit_config" "cloud_config_yaml" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud_config.yaml",
      {
        vhost_ip_map = local.vhost_ip_map
      }
    )
  }
}

resource "time_sleep" "coi-sa" {
  create_duration = "10s"
  depends_on      = [yandex_iam_service_account.coi-sa]
}

resource "yandex_compute_instance_group" "autoscaled-ig-with-coi" {
  name               = "autoscaled-ig-with-coi"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.coi-sa.id
  depends_on = [
    time_sleep.coi-sa,
    yandex_iam_service_account.coi-sa,
    yandex_resourcemanager_folder_iam_member.coi-compute-admin-permissions,
    yandex_resourcemanager_folder_iam_member.coi-vpc-admin-permissions,
    yandex_resourcemanager_folder_iam_member.coi-load-balancer-admin-permissions,
    yandex_resourcemanager_folder_iam_member.coi-iam-serviceAccounts-user-permissions,
  ]
  instance_template {
    service_account_id = yandex_iam_service_account.coi-sa.id
    platform_id        = "standard-v3"
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
      subnet_ids = [
        data.yandex_vpc_subnet.default-ru-central1-a.id,
        data.yandex_vpc_subnet.default-ru-central1-b.id,
        data.yandex_vpc_subnet.default-ru-central1-c.id
      ]
      nat = true
    }

    metadata = {
      docker-container-declaration = file("${path.module}/declaration.yaml")
      user-data                    = data.cloudinit_config.cloud_config_yaml.rendered
      ssh-keys                     = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }

  }

  scale_policy {
    auto_scale {
      initial_size           = 3
      measurement_duration   = 60
      cpu_utilization_target = 75
      #      custom_rules = [
      #        {
      #          labels = {
      #            network_load_balancer = yandex_lb_network_load_balancer.sni_balancer.id
      #          }
      #          metric_name = "network_load_balancer.processed_packets"
      #          metric_type = "GAUGE"
      #          rule_type = "WORKLOAD"
      #          target = 5 # подбирать от нагрузки
      #        },
      #      ]
      min_zone_size          = 1
      max_size               = 15
      warmup_duration        = 60
      stabilization_duration = 120
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-c"
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  load_balancer {
    target_group_name = "coi-target-group"
  }

}

resource "yandex_lb_network_load_balancer" "sni_balancer" {
  name = "sni-balancer"

  listener {
    name        = "coi-listener"
    port        = 443
    target_port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.autoscaled-ig-with-coi.load_balancer.0.target_group_id

    healthcheck {
      name = "healthcheck"
      tcp_options {
        port = 443
      }
    }
  }
}

output "SNILBBalancerIP" {
  description = "Public IP address for docker"
  value       = flatten(flatten(yandex_lb_network_load_balancer.sni_balancer.listener)[0].external_address_spec)[0].address
}
