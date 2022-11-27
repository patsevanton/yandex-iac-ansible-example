## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-storage-admin-static-key" {
  service_account_id = yandex_iam_service_account.sa-storage-admin.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "loki" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.secret_key
  bucket     = "loki-anton-patsev"
  force_destroy = true
}

output "yandex_storage_bucket_loki_access_key" {
  description = "access_key yandex_storage_bucket of loki"
  value       = yandex_storage_bucket.loki.access_key
  sensitive   = true
}

output "yandex_storage_bucket_loki_secret_key" {
  description = "secret_key yandex_storage_bucket of loki"
  value       = yandex_storage_bucket.loki.secret_key
  sensitive   = true
}

output "yandex_storage_bucket_loki_bucket" {
  description = "name bucket of loki"
  value       = yandex_storage_bucket.loki.bucket
  sensitive   = true
}