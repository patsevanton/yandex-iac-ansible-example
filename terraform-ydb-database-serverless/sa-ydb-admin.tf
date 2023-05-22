## Create SA sa-storage-admin
resource "yandex_iam_service_account" "ydb-sa" {
  folder_id = var.yc_folder_id
  name      = "sa-ydb-admin"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-ydb-admin" {
  folder_id = var.yc_folder_id
  role      = "ydb.admin"
  member    = "serviceAccount:${yandex_iam_service_account.ydb-sa.id}"
}

## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "ydb-sa-static-key" {
  service_account_id = yandex_iam_service_account.ydb-sa.id
  description        = "static access key for object storage"
}

resource "local_file" "credentials" {
  content = templatefile("credentials.tftpl",
    {
      access_key = yandex_iam_service_account_static_access_key.ydb-sa-static-key.access_key
      secret_key = yandex_iam_service_account_static_access_key.ydb-sa-static-key.secret_key
    }
  )
  filename = "credentials"
}

output "yandex_storage_bucket_ydb_access_key" {
  description = "access_key yandex_storage_bucket of ydb"
  value       = yandex_iam_service_account_static_access_key.ydb-sa-static-key.access_key
  sensitive   = true
}

output "yandex_storage_bucket_ydb_secret_key" {
  description = "secret_key yandex_storage_bucket of ydb"
  value       = yandex_iam_service_account_static_access_key.ydb-sa-static-key.secret_key
  sensitive   = true
}
