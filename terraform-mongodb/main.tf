module "mongodb-client" {
  source        = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.16.0"
  count         = 1
  image_family  = "ubuntu-2004-lts"
  subnet_id     = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone          = "ru-central1-b"
  name          = "mongodb-client"
  hostname      = "mongodb-client"
  memory        = 2
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  user-data     = file("cloud-init.yaml")
}

resource "yandex_mdb_mongodb_cluster" "mongo" {
  name        = "mongo"
  environment = "PRESTABLE"
  network_id  = data.yandex_vpc_network.default.id

  cluster_config {
    version = "4.4"
  }

  database {
    name = "db1"
  }

  user {
    name     = "user1"
    password = var.password_mongo
    permission {
      database_name = "db1"
      roles         = ["mdbDbAdmin"]
    }
  }

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 16
  }

  host {
    zone_id          = "ru-central1-b"
    subnet_id        = data.yandex_vpc_subnet.default-ru-central1-b.id
    assign_public_ip = true
  }
}

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}

output "external_ip_mongodb_client" {
  value = flatten(module.mongodb-client[*].external_ip[0])
}
