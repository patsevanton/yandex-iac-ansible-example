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

variable "email_letsencrypt" {
  type        = string
  description = "email_letsencrypt"
}

variable "sentry_redis_password" {
  type        = string
  description = "sentry_redis_password"
}
