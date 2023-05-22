## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "ydb-sa-static-key" {
  service_account_id = yandex_iam_service_account.ydb-sa.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "ydb" {
  access_key = yandex_iam_service_account_static_access_key.ydb-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.ydb-sa-static-key.secret_key
  bucket     = "ydb-backet-anton-patsev"
  force_destroy = true
}

resource "local_file" "credentials" {
  content = templatefile("credentials.tpl",
    {
      access_key = yandex_storage_bucket.ydb.access_key
      secret_key = yandex_storage_bucket.ydb.secret_key
    }
  )
  depends_on = [
    yandex_storage_bucket.ydb
  ]
  filename = "credentials"
}

output "yandex_storage_bucket_ydb_access_key" {
  description = "access_key yandex_storage_bucket of ydb"
  value       = yandex_storage_bucket.ydb.access_key
  sensitive   = true
}

output "yandex_storage_bucket_ydb_secret_key" {
  description = "secret_key yandex_storage_bucket of ydb"
  value       = yandex_storage_bucket.ydb.secret_key
  sensitive   = true
}

output "yandex_storage_bucket_ydb_bucket" {
  description = "name bucket of ydb"
  value       = yandex_storage_bucket.ydb.bucket
  sensitive   = true
}
