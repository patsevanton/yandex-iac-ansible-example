
resource "yandex_iam_service_account" "coi-sa" {
  folder_id = var.yc_folder_id
  name      = "coi-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "coi-compute-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.coi-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "coi-vpc-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.coi-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "coi-load-balancer-admin-permissions" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.coi-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "coi-iam-serviceAccounts-user-permissions" {
  folder_id = var.yc_folder_id
  role      = "iam.serviceAccounts.user"
  member    = "serviceAccount:${yandex_iam_service_account.coi-sa.id}"
}
