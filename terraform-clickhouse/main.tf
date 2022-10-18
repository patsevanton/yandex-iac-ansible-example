module "clickhouse-client" {
  source        = "../terraform-yandex-compute"
  count         = 1
  image_family  = "ubuntu-2004-lts"
  subnet_id     = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone          = "ru-central1-b"
  name          = "clickhouse-client"
  hostname      = "clickhouse-client"
  memory        = 2
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  user-data     = file("cloud-init.yaml")
}

resource "yandex_mdb_clickhouse_cluster" "clickhouse" {
  name        = "test"
  environment = "PRESTABLE"
  network_id  = data.yandex_vpc_network.default.id
  depends_on = [
    yandex_iam_service_account.clickhouse-compute-admin
  ]

  clickhouse {
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }

  }

  database {
    name = "db1"
  }

  user {
    name     = "user1"
    password = var.clickhouse_password
    permission {
      database_name = "db1"
    }
    settings {
      max_memory_usage_for_user               = 1000000000
      read_overflow_mode                      = "throw"
      output_format_json_quote_64bit_integers = true
    }
    quota {
      interval_duration = 3600000
      queries           = 10000
      errors            = 1000
    }
    quota {
      interval_duration = 79800000
      queries           = 50000
      errors            = 5000
    }
  }

  host {
    type      = "CLICKHOUSE"
    zone      = "ru-central1-b"
    subnet_id = data.yandex_vpc_subnet.default-ru-central1-b.id
  }

  service_account_id = yandex_iam_service_account.clickhouse-compute-admin.id

  access {
    data_lens = true
  }

  cloud_storage {
    enabled = false
  }

  maintenance_window {
    type = "ANYTIME"
  }
}

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}

output "external_ip_clickhouse_client" {
  value = flatten(module.clickhouse-client[*].external_ip[0])
}

output "fqdn_clickhouse_server" {
  value = yandex_mdb_clickhouse_cluster.clickhouse.host[0].fqdn
}
