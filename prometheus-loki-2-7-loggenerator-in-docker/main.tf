module "lokiindocker" {
  source             = "../terraform-yandex-compute"
  image_family       = var.family_images_linux
  subnet_id          = data.yandex_vpc_subnet.default-ru-central1-a.id
  zone               = data.yandex_vpc_subnet.default-ru-central1-a.zone
  name               = "lokiindocker"
  hostname           = "lokiindocker"
  size               = 100
  is_nat             = true
  preemptible        = true
  core_fraction      = 100
  cores              = 4
  memory             = 16
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  depends_on = [
    yandex_iam_service_account.sa-compute-admin
  ]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user               = var.ssh_user
      hostname_lokiindocker  = "lokiindocker"
      public_ip_lokiindocker = module.lokiindocker.external_ip[0]
    }
  )
  filename = "inventory.yml"
}
