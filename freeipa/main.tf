module "freeipa" {
  source        = "../terraform-yandex-compute"
  image_family  = var.family_images_linux
  subnet_id     = yandex_vpc_subnet.subnet-1.id
  zone          = var.yc_zone
  name          = "freeipa"
  hostname      = "freeipa"
  memory        = "4"
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  user          = var.ssh_user
  depends_on = [
    yandex_vpc_subnet.subnet-1
  ]
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user           = var.ssh_user
      hostname           = var.hostname
      freeipa_public_ip  = module.freeipa.external_ip[0]
      letsencrypt_domain = var.letsencrypt_domain
    }
  )
  filename = "inventory.yml"
}

output "freeipa_public_ip" {
  description = "Public IP address for active directory"
  value       = module.freeipa.external_ip[0]
}