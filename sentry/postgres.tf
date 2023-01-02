resource "yandex_mdb_postgresql_cluster" "sentry_vm_postgres" {
  name        = "sentry_vm_postgres"
  environment = "PRODUCTION"
  network_id  = data.yandex_vpc_network.default.id

  config {
    version = "11"
    resources {
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 40
    }
  }

  host {
    zone             = "ru-central1-b"
    name             = "sentry_vm_postgres_host"
    subnet_id        = data.yandex_vpc_subnet.default-ru-central1-b.id
    assign_public_ip = true
  }
}

resource "yandex_mdb_postgresql_database" "sentry" {
  cluster_id = yandex_mdb_postgresql_cluster.sentry_vm_postgres.id
  name       = "sentry"
  owner      = "sentry"
  depends_on = [
    yandex_mdb_postgresql_user.sentry
  ]
}

resource "yandex_mdb_postgresql_user" "sentry" {
  cluster_id = yandex_mdb_postgresql_cluster.sentry_vm_postgres.id
  name       = "sentry"
  password   = var.sentry_postgres_password
  grants     = [ "mdb_admin" ]
}

output fqdn_sentry_postgres {
  value = "c-${yandex_mdb_postgresql_cluster.sentry_vm_postgres.id}.rw.mdb.yandexcloud.net"
}

output sentry_postgres_password {
  value = var.sentry_postgres_password
  sensitive = true
}
