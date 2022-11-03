resource "yandex_mdb_redis_cluster" "myredis" {
  name                = "myredis"
  environment         = "PRODUCTION"
  network_id          = data.yandex_vpc_network.default.id

  config {
    password = var.password
    version  = "6.2"
  }

  resources {
    resource_preset_id = "hm3-c2-m8"
    disk_type_id       = "network-ssd"
    disk_size          = 16
  }

  host {
    zone       = "ru-central1-a"
    subnet_id  = data.yandex_vpc_subnet.default-ru-central1-a.id
  }

  host {
    zone       = "ru-central1-b"
    subnet_id  = data.yandex_vpc_subnet.default-ru-central1-b.id
  }

#  host {
#    zone       = "ru-central1-c"
#    subnet_id  = data.yandex_vpc_subnet.default-ru-central1-c.id
#  }
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

variable "yc_token" {
  type        = string
  description = "Yandex Cloud API key"
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud id"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
}

variable "password" {
  type        = string
  description = "password"
}
