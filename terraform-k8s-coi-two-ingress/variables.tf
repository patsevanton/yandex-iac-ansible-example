# Variables

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

variable "vhost_ip_map" {
  type = map(string)
  default = {
    "url1" = "ip1"
    "url2" = "ip2"
  }
}
