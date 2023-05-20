module "ydb-client" {
  source             = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
  count              = 1
  image_family       = "ubuntu-2004-lts"
  subnet_id          = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone               = "ru-central1-b"
  name               = "ydb-client"
  hostname           = "ydb-client"
  memory             = 2
  is_nat             = true
  preemptible        = true
  core_fraction      = 50
  service_account_id = yandex_iam_service_account.ydb-sa-viewer-editor.id
  user-data          = file("cloud-init.yaml")
}

resource "yandex_ydb_database_dedicated" "database1" {
  name = "test-ydb-dedicated"

  network_id = data.yandex_vpc_network.default.id
  subnet_ids = [
    data.yandex_vpc_subnet.default-ru-central1-a.id,
    data.yandex_vpc_subnet.default-ru-central1-b.id,
    data.yandex_vpc_subnet.default-ru-central1-c.id,
  ]

  resource_preset_id = "medium"
  assign_public_ips  = true

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  storage_config {
    group_count     = 1
    storage_type_id = "ssd"
  }

  location {
    region {
      id = "ru-central1"
    }
  }
}

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-a" {
  name = "default-ru-central1-a"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}

data "yandex_vpc_subnet" "default-ru-central1-c" {
  name = "default-ru-central1-c"
}

output "external_ip_ydb_client" {
  value = flatten(module.ydb-client[*].external_ip[0])
}
