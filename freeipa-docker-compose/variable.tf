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

variable "yc_zone" {
  type        = string
  description = "Yandex Cloud compute default zone"
  default     = "ru-central1-b"
}

variable "family_images_linux" {
  type        = string
  description = "Family of images jenkins in Yandex Cloud. Example: ubuntu-2004-lts"
  default     = "ubuntu-2004-lts"
}

variable "ssh_user" {
  type        = string
  description = "ssh_user"
  default     = "ubuntu"
}

variable "cores" {
  type        = string
  description = "Cores CPU. Examples: 2, 4, 6, 8 and more"
  default     = 2
}

variable "memory" {
  type        = string
  description = "Memory GB. Examples: 2, 4, 6, 8 and more"
  default     = 4
}

variable "disk_size" {
  type        = string
  description = "Disk size GB. Min 50 for Windows."
  default     = 50
}

variable "disk_type" {
  type        = string
  description = "Disk type. Examples: network-ssd, network-hdd, network-ssd-nonreplicated"
  default     = "network-ssd"
}

variable "hostname" {
  type        = string
  description = "hostname"
}

variable "letsencrypt_domain" {
  type        = string
  description = "letsencrypt_domain"
  default     = "sslip.io"
}
