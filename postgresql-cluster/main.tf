data "yandex_compute_image" "family_images_linux" {
  family = var.family_images_linux
}

resource "yandex_compute_instance" "master" {
  count              = 1
  name               = "master${count.index}"
  platform_id        = "standard-v3"
  hostname           = "master${count.index}"
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  resources {
    cores  = var.cores
    memory = var.memory
  }
  boot_disk {
    initialize_params {
      size     = var.disk_size
      type     = var.disk_type
      image_id = data.yandex_compute_image.family_images_linux.id
    }
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "var.ssh_user:${file("~/.ssh/id_rsa.pub")}"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.network_interface.0.nat_ip_address
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "echo check connection"
    ]
  }
}

resource "yandex_compute_instance" "replica" {
  count              = 2
  name               = "replica${count.index}"
  platform_id        = "standard-v3"
  hostname           = "replica${count.index}"
  service_account_id = yandex_iam_service_account.sa-compute-admin.id
  resources {
    cores  = var.cores
    memory = var.memory
  }
  boot_disk {
    initialize_params {
      size     = var.disk_size
      type     = var.disk_type
      image_id = data.yandex_compute_image.family_images_linux.id
    }
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "var.ssh_user:${file("~/.ssh/id_rsa.pub")}"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.network_interface.0.nat_ip_address
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "echo check connection"
    ]
  }
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
[etcd_cluster]  # recommendation: 3 or 5-7 nodes
%{for node in yandex_compute_instance.master~}
${node.network_interface.0.nat_ip_address} ip=${node.network_interface.0.ip_address}
%{endfor~}
%{for node in yandex_compute_instance.replica~}
${node.network_interface.0.nat_ip_address} ip=${node.network_interface.0.ip_address}
%{endfor~}

# if with_haproxy_load_balancing: true (in vars/main.yml)
[balancers]
%{for node in yandex_compute_instance.master~}
${node.network_interface.0.nat_ip_address} ip=${node.network_interface.0.ip_address}
%{endfor~}
%{for node in yandex_compute_instance.replica~}
${node.network_interface.0.nat_ip_address} ip=${node.network_interface.0.ip_address}
%{endfor~}

# PostgreSQL nodes
[master]
%{for node in yandex_compute_instance.master~}
${node.network_interface.0.nat_ip_address} hostname=${node.name} postgresql_exists='false'
%{endfor~}

[replica]
%{for node in yandex_compute_instance.replica~}
${node.network_interface.0.nat_ip_address} hostname=${node.name} postgresql_exists='false'
%{endfor~}

[postgres_cluster:children]
master
replica

# Connection settings
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
}
