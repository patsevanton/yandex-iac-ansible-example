module "seaweedfs" {
  source             = "git::https://github.com/patsevanton/terraform-yandex-compute.git?ref=v1.23.0"
  image_family       = var.family_images_linux
  subnet_id          = yandex_vpc_subnet.subnet-1.id
  zone               = var.yc_zone
  name               = "seaweedfs"
  hostname           = "seaweedfs"
  is_nat             = true
  preemptible        = true
  core_fraction      = 50
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  depends_on = [
    yandex_vpc_subnet.subnet-1,
    yandex_iam_service_account.sa-compute-admin
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

resource "local_file" "host_ini" {
  filename = "host.ini"
  content  = <<-EOT
[weed_master]
${module.seaweedfs.external_ip[0]}
[weed_volume]
${module.seaweedfs.external_ip[0]}
[weed_filer]
${module.seaweedfs.external_ip[0]}
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
}
