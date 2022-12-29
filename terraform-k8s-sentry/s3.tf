## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-storage-admin-static-key" {
  service_account_id = yandex_iam_service_account.sa-storage-admin.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "sentry" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.secret_key
  bucket     = "sentry-anton-patsev"
  force_destroy = true
}

output "access_key_sa_storage_admin_for_test_bucket" {
  description = "access_key sa-storage-admin for sentry"
  value       = yandex_storage_bucket.sentry.access_key
  sensitive   = true
}

output "secret_key_sa_storage_admin_for_test_bucket" {
  description = "secret_key sa-storage-admin for sentry"
  value       = yandex_storage_bucket.sentry.secret_key
  sensitive   = true
}
