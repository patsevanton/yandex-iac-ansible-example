resource "yandex_mdb_postgresql_cluster" "test" {
  name                = "test"
  environment         = "PRODUCTION"
  network_id          = data.yandex_vpc_network.default.id

  config {
    version = "15"
    resources {
      resource_preset_id = "c3-c2-m4"
      disk_type_id       = "network-ssd"
      disk_size          = 20
    }
    performance_diagnostics {
      enabled = true
      sessions_sampling_interval  = 60
      statements_sampling_interval = 600
    }
  }

  host {
    zone      = data.yandex_vpc_subnet.default-ru-central1-a.zone
    subnet_id = data.yandex_vpc_subnet.default-ru-central1-a.id
    assign_public_ip = true
  }
  host {
    zone      = data.yandex_vpc_subnet.default-ru-central1-a.zone
    subnet_id = data.yandex_vpc_subnet.default-ru-central1-a.id
    assign_public_ip = true
  }
  host {
    zone      = data.yandex_vpc_subnet.default-ru-central1-b.zone
    subnet_id = data.yandex_vpc_subnet.default-ru-central1-b.id
    assign_public_ip = true
  }

}

resource "yandex_mdb_postgresql_database" "test" {
  cluster_id = yandex_mdb_postgresql_cluster.test.id
  name       = "test"
  owner      = "test"
  depends_on = [
    yandex_mdb_postgresql_user.test
  ]
}

resource "yandex_mdb_postgresql_user" "test" {
  cluster_id = yandex_mdb_postgresql_cluster.test.id
  name       = "test"
  password   = "dsgvdgsbsdznbzdfsndf"
}
