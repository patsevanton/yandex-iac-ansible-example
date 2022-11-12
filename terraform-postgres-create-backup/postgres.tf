resource "yandex_mdb_postgresql_cluster" "testrestoredb" {
  name        = "testrestoredb"
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

}

resource "yandex_mdb_postgresql_database" "testrestoredb" {
  cluster_id = yandex_mdb_postgresql_cluster.testrestoredb.id
  name       = "testrestoredb"
  owner      = "testrestoredb"
  depends_on = [
    yandex_mdb_postgresql_user.testrestoredb
  ]
}


resource "yandex_mdb_postgresql_user" "testrestoredb" {
  cluster_id = yandex_mdb_postgresql_cluster.testrestoredb.id
  name       = "testrestoredb"
  password   = var.psql_password
}