## Create SA sa-storage-admin
resource "yandex_iam_service_account" "ydb-sa" {
  folder_id = var.yc_folder_id
  name      = "sa-storage-admin"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-storage-admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.ydb-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-compute-admin" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.ydb-sa.id}"
}
