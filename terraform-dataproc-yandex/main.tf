module "dataproc-client" {
  source        = "../terraform-yandex-compute"
  count         = 1
  image_family  = "ubuntu-2004-lts"
  subnet_id     = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone          = "ru-central1-b"
  name          = "dataproc-client"
  hostname      = "dataproc-client"
  memory        = 2
  is_nat        = true
  preemptible   = true
  core_fraction = 50
}

resource "yandex_dataproc_cluster" "foo" {
  depends_on = [yandex_resourcemanager_folder_iam_member.dataproc]

  bucket      = yandex_storage_bucket.bucket-apatsev.bucket
  description = "Dataproc Cluster created by Terraform"
  name        = "dataproc-cluster"
  labels = {
    created_by = "terraform"
  }
  service_account_id = yandex_iam_service_account.dataproc.id
  zone_id            = "ru-central1-b"
  ui_proxy           = true

  cluster_config {
    # Certain cluster version can be set, but better to use default value (last stable version)
    # version_id = "1.4"

    hadoop {
      services = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
      properties = {
        "yarn:yarn.resourcemanager.am.max-attempts" = 5
      }
      ssh_public_keys = [
      file("~/.ssh/id_rsa.pub")]
    }

    subcluster_spec {
      name = "main"
      role = "MASTERNODE"
      resources {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id   = data.yandex_vpc_subnet.default-ru-central1-b.id
      hosts_count = 1
    }

    subcluster_spec {
      name = "data"
      role = "DATANODE"
      resources {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id   = data.yandex_vpc_subnet.default-ru-central1-b.id
      hosts_count = 2
    }

    subcluster_spec {
      name = "compute"
      role = "COMPUTENODE"
      resources {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id   = data.yandex_vpc_subnet.default-ru-central1-b.id
      hosts_count = 2
    }

    subcluster_spec {
      name = "compute_autoscaling"
      role = "COMPUTENODE"
      resources {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id   = data.yandex_vpc_subnet.default-ru-central1-b.id
      hosts_count = 2
      autoscaling_config {
        max_hosts_count        = 10
        measurement_duration   = 60
        warmup_duration        = 60
        stabilization_duration = 120
        preemptible            = false
        decommission_timeout   = 60
      }
    }
  }
}

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}


resource "yandex_iam_service_account" "dataproc" {
  name        = "dataproc"
  description = "service account to manage Dataproc Cluster"
}

data "yandex_resourcemanager_folder" "default" {
  name = "default"
}

resource "yandex_resourcemanager_folder_iam_member" "dataproc" {
  folder_id = data.yandex_resourcemanager_folder.default.id
  role      = "mdb.dataproc.agent"
  member    = "serviceAccount:${yandex_iam_service_account.dataproc.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket-creator" {
  folder_id = data.yandex_resourcemanager_folder.default.id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.dataproc.id}"
}

resource "yandex_iam_service_account_static_access_key" "foo" {
  service_account_id = yandex_iam_service_account.dataproc.id
}

resource "yandex_storage_bucket" "bucket-apatsev" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.bucket-creator
  ]

  bucket     = "bucket-apatsev"
  access_key = yandex_iam_service_account_static_access_key.foo.access_key
  secret_key = yandex_iam_service_account_static_access_key.foo.secret_key
}

output "external_ip_dataproc_client" {
  value = flatten(module.dataproc-client[*].external_ip[0])
}
