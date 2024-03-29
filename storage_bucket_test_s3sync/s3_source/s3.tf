## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-storage-admin-static-key" {
  service_account_id = data.yandex_iam_service_account.sa-storage-admin.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "test-s3sync-source-anton-patsev" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.secret_key
  bucket     = "test-s3sync-source-anton-patsev"

}

output "access_key_sa_storage_admin_for_test_bucket" {
  description = "access_key sa-storage-admin for test-s3sync-source-anton-patsev"
  value       = yandex_storage_bucket.test-s3sync-source-anton-patsev.access_key
  sensitive   = true
}

output "secret_key_sa_storage_admin_for_test_bucket" {
  description = "secret_key sa-storage-admin for test-s3sync-source-anton-patsev"
  value       = yandex_storage_bucket.test-s3sync-source-anton-patsev.secret_key
  sensitive   = true
}
