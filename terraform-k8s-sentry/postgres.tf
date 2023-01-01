resource "yandex_mdb_postgresql_cluster" "sentry_postgres" {
  name                = "sentry_postgres"
  environment         = "PRODUCTION"
  network_id          = "enprkje8ae9b74e0himb" # default network

  config {
    version = "15"
    resources {
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 20
    }
  }

  host {
    zone      = "ru-central1-b"
    name      = "sentry_postgres_host"
    subnet_id = "e2l6251f60t5e6faq3o7" # default-ru-central1-b
    assign_public_ip = true
  }
}

resource "yandex_mdb_postgresql_database" "sentry" {
  cluster_id = yandex_mdb_postgresql_cluster.sentry_postgres.id
  name       = "sentry"
  owner      = "sentry"
  depends_on = [
    yandex_mdb_postgresql_user.sentry
  ]
}

resource "yandex_mdb_postgresql_user" "sentry" {
  cluster_id = yandex_mdb_postgresql_cluster.sentry_postgres.id
  name       = "sentry"
  password   = var.sentry_postgres_password
  grants     = [ "mdb_admin" ]
  permission {
    database_name = "sentry"
  }
}

output fqdn_sentry_postgres {
  value = "c-${yandex_mdb_postgresql_cluster.sentry_postgres.id}.rw.mdb.yandexcloud.net"
}

output sentry_postgres_password {
  value = var.sentry_postgres_password
  sensitive = true
}
