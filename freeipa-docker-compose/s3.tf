## Create SA sa-storage-admin
resource "yandex_iam_service_account" "freeipa-sa-storage-admin" {
  folder_id = var.yc_folder_id
  name      = "freeipa-sa-storage-admin"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "freeipa-sa-storage-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.freeipa-sa-storage-admin.id}"
}

## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "freeipa-sa-storage-admin-static-key" {
  service_account_id = yandex_iam_service_account.freeipa-sa-storage-admin.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "anton-patsev-freeipa-backup" {
  access_key = yandex_iam_service_account_static_access_key.freeipa-sa-storage-admin-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.freeipa-sa-storage-admin-static-key.secret_key
  bucket     = "anton-patsev-freeipa-backup"
}

output "access_key_sa_storage_admin_for_bucket" {
  description = "access_key sa-storage-admin for anton-patsev-freeipa-backup"
  value       = yandex_storage_bucket.anton-patsev-freeipa-backup.access_key
  sensitive   = true
}

output "secret_key_sa_storage_admin_for_bucket" {
  description = "secret_key sa-storage-admin for anton-patsev-freeipa-backup"
  value       = yandex_storage_bucket.anton-patsev-freeipa-backup.secret_key
  sensitive   = true
}
