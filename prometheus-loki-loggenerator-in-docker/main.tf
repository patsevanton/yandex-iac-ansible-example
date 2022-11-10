module "javaindocker" {
  source             = "../terraform-yandex-compute"
  image_family       = var.family_images_linux
  subnet_id          = data.yandex_vpc_subnet.default-ru-central1-a.id
  zone               = var.yc_zone
  name               = "javaindocker"
  hostname           = "javaindocker"
  size               = 30
  is_nat             = true
  preemptible        = true
  core_fraction      = 50
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  depends_on = [
    yandex_iam_service_account.sa-compute-admin
  ]
}

module "prometheus" {
  source             = "../terraform-yandex-compute"
  image_family       = var.family_images_linux
  subnet_id          = data.yandex_vpc_subnet.default-ru-central1-a.id
  zone               = var.yc_zone
  name               = "prometheus"
  hostname           = "prometheus"
  is_nat             = true
  preemptible        = true
  core_fraction      = 50
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  depends_on = [
    yandex_iam_service_account.sa-compute-admin
  ]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user               = var.ssh_user
      hostname_prometheus    = "prometheus"
      hostname_javaindocker  = "javaindocker"
      public_ip_prometheus   = module.prometheus.external_ip[0]
      public_ip_javaindocker = module.javaindocker.external_ip[0]
      domain                 = var.domain
    }
  )
  filename = "inventory.yml"
}
