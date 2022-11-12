resource "yandex_mdb_postgresql_cluster" "testrestorefromdb" {
  name        = "testrestorefromdb"
  environment = "PRODUCTION"
  network_id  = data.yandex_vpc_network.default.id

  config {
    version = "15"
    resources {
      resource_preset_id = "b1.medium"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
  }

  host {
    zone      = data.yandex_vpc_subnet.default-ru-central1-b.zone
    subnet_id = data.yandex_vpc_subnet.default-ru-central1-b.id
    assign_public_ip = true
  }

  restore {
    backup_id = "c9qap730mfh3upc4mpfo:c9qaurpimhl6074t04r8"
  }
}
