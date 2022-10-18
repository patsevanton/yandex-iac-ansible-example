## Create SA sa-compute-admin
resource "yandex_iam_service_account" "sa-compute-admin" {
  folder_id = var.yc_folder_id
  name      = "sa-compute-admin"
}

## Grant permissions sa-compute-admin
resource "yandex_resourcemanager_folder_iam_member" "sa-compute-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-compute-admin.id}"
}
