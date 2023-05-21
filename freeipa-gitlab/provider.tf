terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.91.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}
