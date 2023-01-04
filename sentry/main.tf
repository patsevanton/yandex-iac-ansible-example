module "sentry" {
  source             = "../terraform-yandex-compute"
  image_family       = var.family_images_linux
  subnet_id          = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone               = var.yc_zone
  name               = "sentry"
  hostname           = "sentry"
  cores              = 4
  memory             = 16
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
      ssh_user  = var.ssh_user
      hostname  = var.hostname
      public_ip = module.sentry.external_ip[0]
      domain    = var.domain
    }
  )
  filename = "inventory.yml"
}
