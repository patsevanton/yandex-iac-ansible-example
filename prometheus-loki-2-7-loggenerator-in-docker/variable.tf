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

