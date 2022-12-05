## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "velero-sa-static-key" {
  service_account_id = yandex_iam_service_account.velero-sa.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "velero" {
  access_key = yandex_iam_service_account_static_access_key.velero-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.velero-sa-static-key.secret_key
  bucket     = "velero-backet-anton-patsev"
  force_destroy = true
}

output "yandex_storage_bucket_velero_access_key" {
  description = "access_key yandex_storage_bucket of velero"
  value       = yandex_storage_bucket.velero.access_key
  sensitive   = true
}

output "yandex_storage_bucket_velero_secret_key" {
  description = "secret_key yandex_storage_bucket of velero"
  value       = yandex_storage_bucket.velero.secret_key
  sensitive   = true
}

output "yandex_storage_bucket_velero_bucket" {
  description = "name bucket of velero"
  value       = yandex_storage_bucket.velero.bucket
  sensitive   = true
}