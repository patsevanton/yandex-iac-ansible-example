resource "yandex_mdb_redis_cluster" "sentry_redis" {
  name                = "sentry_redis"
  environment         = "PRODUCTION"
  network_id          = data.yandex_vpc_network.default.id

  config {
    password = var.redis_password
    version  = "6.2"
  }

  resources {
    resource_preset_id = "b3-c1-m4"
    disk_type_id       = "network-ssd"
    disk_size          = 16
  }

  host {
    zone             = data.yandex_vpc_subnet.default-ru-central1-a.zone
    subnet_id        = data.yandex_vpc_subnet.default-ru-central1-a.id
    assign_public_ip = false
    replica_priority = 50
  }
}
