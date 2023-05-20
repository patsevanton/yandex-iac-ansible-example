data "yandex_compute_image" "family_freeipa_linux" {
  family = var.family_freeipa_linux
}

data "yandex_compute_image" "family_images_linux" {
  family = var.family_images_linux
}

module "freeipa" {
  source        = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.16.0"
  image_family  = var.family_freeipa_linux
  subnet_id     = yandex_vpc_subnet.subnet-1.id
  zone          = var.yc_zone
  name          = "freeipa"
  hostname      = "freeipa"
  memory        = "4"
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  user          = var.ssh_freeipa_user
  depends_on = [
    yandex_vpc_subnet.subnet-1
  ]
}

module "gitlab" {
  source        = "../terraform-yandex-compute"
  image_family  = var.family_images_linux
  subnet_id     = yandex_vpc_subnet.subnet-1.id
  zone          = var.yc_zone
  name          = "gitlab"
  hostname      = "gitlab"
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

output "freeipa_public_ip" {
  description = "Public IP address for active directory"
  value       = module.freeipa.external_ip[0]
}

output "public_ip_gitlab" {
  description = "Public IP address for gitlab"
  value       = module.gitlab.external_ip[0]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_freeipa_user          = var.ssh_freeipa_user
      freeipa_hostname          = var.freeipa_hostname
      freeipa_public_ip         = module.freeipa.external_ip[0]
      gitlab_hostname           = var.gitlab_hostname
      public_ip_gitlab          = module.gitlab.external_ip[0]
      letsencrypt_domain        = var.letsencrypt_domain
      pswd_gitlab_ldap_sync     = var.pswd_gitlab_ldap_sync
      pswd_test_user_in_freeipa = var.pswd_test_user_in_freeipa
      ssh_user                  = var.ssh_user
    }
  )
  filename = "inventory.yml"
}
