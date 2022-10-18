resource "yandex_iam_service_account" "ydb-sa-viewer-editor" {
  folder_id = var.yc_folder_id
  name      = "ydb-sa-viewer-editor"
}

resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-viewer-permissions" {
  folder_id = var.yc_folder_id
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.ydb-sa-viewer-editor.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "ydb-sa-editor-permissions" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ydb-sa-viewer-editor.id}"
}
