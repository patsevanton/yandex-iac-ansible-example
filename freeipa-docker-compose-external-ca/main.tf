module "freeipa" {
  source        = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.16.0"
  image_family  = "ubuntu-2004-lts"
  subnet_id     = data.yandex_vpc_subnet.default-ru-central1-b.id
  zone          = data.yandex_vpc_subnet.default-ru-central1-b.zone
  name          = "freeipa"
  hostname      = "freeipa"
  memory        = "4"
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  user          = var.ssh_user
  ssh_pubkey    = "~/.ssh/id_ecdsa.pub"
  private_key   = "~/.ssh/id_ecdsa"
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user           = var.ssh_user
      freeipa_public_ip  = module.freeipa.external_ip[0]
      freeipa_password   = var.freeipa_password
      freeipa_fqdn       = var.freeipa_fqdn
      freeipa_domain     = var.freeipa_domain
      ssh_user           = var.ssh_user
    }
  )
  filename = "inventory.yml"
}

output "freeipa_public_ip" {
  description = "Public IP address for active directory"
  value       = module.freeipa.external_ip[0]
}