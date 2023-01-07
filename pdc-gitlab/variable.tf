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

variable "family_images_windows" {
  type        = string
  description = "Family of images windows in Yandex Cloud. Example: windows-2022-dc-gvlk, windows-2019-dc-gvlk"
}

variable "family_images_linux" {
  type        = string
  description = "Family of images gitlab in Yandex Cloud. Example: ubuntu-2004-lts"
}

variable "ssh_user" {
  type        = string
  description = "ssh_user"
  default     = "ubuntu"
}

variable "pdc_admin_password" {
  type        = string
  description = "Password for PDC"
}

variable "pdc_hostname" {
  type        = string
  description = "pdc_hostname"
}

variable "gitlab_hostname" {
  type        = string
  description = "gitlab_hostname"
}

variable "pdc_domain" {
  type        = string
  description = "pdc_domain"
}

variable "pdc_domain_path" {
  type        = string
  description = "pdc_domain_path"
}

variable "letsencrypt_domain" {
  type        = string
  description = "letsencrypt_domain"
  default     = "sslip.io"
}

variable "pswd_gitlab_ldap_sync" {
  type        = string
  description = "pswd_gitlab_ldap_sync"
}

variable "pswd_test_user_in_pdc" {
  type        = string
  description = "pswd_test_user_in_pdc"
}
