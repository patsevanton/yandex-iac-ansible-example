data "yandex_compute_image" "family_images_windows" {
  family = var.family_images_windows
}

data "yandex_compute_image" "family_images_linux" {
  family = var.family_images_linux
}


data "template_file" "userdata_win" {
  template = file("user_data.tmpl")
  vars = {
    pdc_admin_password = var.pdc_admin_password
  }
}

module "pdc" {
  source           = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
  image_family     = var.family_images_windows
  memory           = 4
  subnet_id        = yandex_vpc_subnet.subnet-1.id
  zone             = var.yc_zone
  name             = "pdc"
  hostname         = "pdc"
  is_nat           = true
  user-data        = data.template_file.userdata_win.rendered
  type_remote_exec = "winrm"
  user             = "Administrator"
  password         = var.pdc_admin_password
  https            = true
  port             = 5986
  insecure         = true
  timeout          = "20m"
  size             = 50
  preemptible      = true
  core_fraction    = 50
  depends_on       = [yandex_vpc_subnet.subnet-1]
}

module "gitlab" {
  source        = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
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

output "public_ip_pdc" {
  description = "Public IP address for active directory"
  value       = module.pdc.external_ip[0]
}

output "public_ip_gitlab" {
  description = "Public IP address for gitlab"
  value       = module.gitlab.external_ip[0]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      pdc_admin_password    = var.pdc_admin_password
      pdc_hostname          = var.pdc_hostname
      pdc_domain            = var.pdc_domain
      pdc_domain_path       = var.pdc_domain_path
      public_ip_pdc         = module.pdc.external_ip[0]
      gitlab_hostname       = var.gitlab_hostname
      public_ip_gitlab      = module.gitlab.external_ip[0]
      letsencrypt_domain    = var.letsencrypt_domain
      pswd_gitlab_ldap_sync = var.pswd_gitlab_ldap_sync
      pswd_test_user_in_pdc = var.pswd_test_user_in_pdc
      ssh_user              = var.ssh_user
    }
  )
  filename = "inventory.yml"
}
