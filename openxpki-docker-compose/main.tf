module "openxpki" {
  source         = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
  image_family   = var.family_images_linux
  subnet_id      = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone           = data.yandex_vpc_subnet.default-ru-central1-b.zone
  name           = "openxpki"
  hostname       = "openxpki"
  memory         = "4"
  is_nat         = true
  preemptible    = true
  core_fraction  = 50
  user           = var.ssh_user
  nat_ip_address = var.nat_ip_address
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user          = var.ssh_user
      openxpki_public_ip = module.openxpki.external_ip[0]
      openxpki_password  = var.openxpki_password
      openxpki_fqdn      = var.openxpki_fqdn
      openxpki_domain    = var.openxpki_domain
      ssh_user          = var.ssh_user
      access_key        = access_key
      secret_key        = secret_key
      bucket            = bucket
    }
  )
  filename = "inventory.yml"
}

output "openxpki_public_ip" {
  description = "Public IP address for active directory"
  value       = module.openxpki.external_ip[0]
}
