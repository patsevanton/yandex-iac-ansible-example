## Create SA sa-storage-admin
resource "yandex_iam_service_account" "sa-storage-admin" {
  folder_id = var.yc_folder_id
  name      = "sa-storage-admin"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-storage-admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-storage-admin.id}"
}
