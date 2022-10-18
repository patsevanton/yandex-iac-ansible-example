module "jenkins" {
  source             = "../terraform-yandex-compute"
  image_family       = var.family_images_linux
  subnet_id          = yandex_vpc_subnet.subnet-1.id
  zone               = var.yc_zone
  name               = "jenkins"
  hostname           = "jenkins"
  is_nat             = true
  preemptible        = true
  core_fraction      = 50
  user               = var.ssh_user
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

resource "local_file" "inventory_yml" {
  content = templatefile("inventory_yml.tpl",
    {
      ssh_user  = var.ssh_user
      hostname  = var.hostname
      public_ip = module.jenkins.external_ip[0]
      domain    = var.domain

      jenkins_admin_password    = var.jenkins_admin_password
      googleoauth2_clientid     = var.googleoauth2_clientid
      googleoauth2_clientsecret = var.googleoauth2_clientsecret
      googleoauth2_domain       = var.googleoauth2_domain
    }
  )
  filename = "inventory.yml"
}


# provisioner "local-exec" {
#     command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.ssh_key_private} provision.yml"
# }
