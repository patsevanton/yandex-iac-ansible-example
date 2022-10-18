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
  description = "Family of images gitlab in Yandex Cloud. Example: ubuntu-2004-lts"
}

variable "family_freeipa_linux" {
  type        = string
  description = "family_freeipa_linux"
}

variable "ssh_user" {
  type        = string
  description = "ssh_user"
}

variable "ssh_freeipa_user" {
  type        = string
  description = "ssh_freeipa_user"
}

variable "freeipa_hostname" {
  type        = string
  description = "freeipa_hostname"
}

variable "gitlab_hostname" {
  type        = string
  description = "gitlab_hostname"
}

variable "freeipa_domain" {
  type        = string
  description = "freeipa_domain"
}

variable "freeipa_domain_path" {
  type        = string
  description = "freeipa_domain_path"
}

variable "letsencrypt_domain" {
  type        = string
  description = "letsencrypt_domain"
}

variable "pswd_gitlab_ldap_sync" {
  type        = string
  description = "pswd_gitlab_ldap_sync"
}

variable "pswd_test_user_in_freeipa" {
  type        = string
  description = "pswd_test_user_in_freeipa"
}
