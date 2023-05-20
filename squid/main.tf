module "squid" {
  source        = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.16.0"
  image_family  = "ubuntu-2004-lts"
  subnet_id     = yandex_vpc_subnet.subnet-1.id
  zone          = var.yc_zone
  name          = "squid"
  hostname      = "squid"
  is_nat        = true
  preemptible   = true
  core_fraction = 50
  depends_on    = [yandex_vpc_subnet.subnet-1]
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user  = var.ssh_user
      public_ip = module.squid.external_ip[0]
      hostname  = "squid"
    }
  )
  filename = "inventory.yml"
}
