## Create SA sa-compute-admin
resource "yandex_iam_service_account" "clickhouse-compute-admin" {
  folder_id = var.yc_folder_id
  name      = "clickhouse-compute-admin"
}

## Grant permissions sa-compute-admin
resource "yandex_resourcemanager_folder_iam_member" "clickhouse-compute-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.clickhouse-compute-admin.id}"
}
