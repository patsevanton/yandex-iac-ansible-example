
data "yandex_iam_service_account" "sa-storage-admin" {
  folder_id = var.yc_folder_id
  name      = "sa-storage-admin"
}

