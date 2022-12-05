## Create SA sa-storage-admin
resource "yandex_iam_service_account" "velero-sa" {
  folder_id = var.yc_folder_id
  name      = "sa-storage-admin"
}

## Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "velero-sa-storage-admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.velero-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "velero-sa-compute-admin" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.velero-sa.id}"
}
