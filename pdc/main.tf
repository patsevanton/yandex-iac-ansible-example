data "template_file" "userdata_win" {
  template = file("user_data.tmpl")
  vars = {
    pdc_admin_password = var.pdc_admin_password
  }
}

data "yandex_compute_image" "family_images_windows" {
  family = var.family_images_windows
}

resource "yandex_vpc_network" "network-pdc-01" {
  name = "network-pdc-01"
}

resource "yandex_vpc_subnet" "subnet-pdc-01" {
  name           = "subnet-pdc-01"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-pdc-01.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

module "pdc" {
  source           = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
  image_family     = var.family_images_windows
  memory           = var.memory
  subnet_id        = yandex_vpc_subnet.subnet-pdc-01.id
  zone             = var.yc_zone
  name             = var.hostname
  hostname         = var.hostname
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
  depends_on       = [yandex_vpc_subnet.subnet-pdc-01]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      pdc_admin_password = var.pdc_admin_password
      pdc_hostname       = var.hostname
      pdc_domain         = var.pdc_domain
      pdc_domain_path    = var.pdc_domain_path
      pfx_password       = var.pfx_password
      public_ip          = module.pdc.external_ip[0]
    }
  )
  filename = "inventory.yml"
}
