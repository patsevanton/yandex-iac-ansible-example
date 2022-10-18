data "yandex_compute_image" "this" {
  family = var.image_family
}

resource "yandex_compute_disk" "disks" {
  for_each = var.secondary_disk
  name     = each.key
  size     = each.value["size"]
}

resource "yandex_compute_instance" "this" {
  count = var.instance_count

  name               = var.name
  platform_id        = var.platform_id
  zone               = var.zone
  description        = var.description
  hostname           = var.hostname
  folder_id          = var.folder_id
  service_account_id = var.service_account_id
  labels             = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
      type     = var.type
      size     = var.size
    }
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }

  dynamic "secondary_disk" {
    for_each = var.secondary_disk
    content {
      auto_delete = lookup(secondary_disk.value, "auto_delete", true)
      disk_id     = yandex_compute_disk.disks[secondary_disk.key].id
    }
  }

  network_interface {
    subnet_id      = var.subnet_id
    nat            = var.is_nat
    nat_ip_address = var.nat_ip_address
    ip_address     = var.ip_address
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    user-data          = length(var.user-data) > 0 ? var.user-data : null
    ssh-keys           = "${var.user}:${file("${var.ssh_pubkey}")}"
    serial-port-enable = var.serial-port-enable != null ? var.serial-port-enable : null
  }

  allow_stopping_for_update = var.allow_stopping_for_update

  provisioner "remote-exec" {
    connection {
      type        = var.type_remote_exec
      user        = var.user
      host        = self.network_interface["0"].nat_ip_address
      private_key = file("${var.private_key}")
      password    = var.password
      https       = length(var.https) > 0 ? var.https : null
      port        = var.port
      insecure    = length(var.insecure) > 0 ? var.insecure : null
      timeout     = var.timeout
    }
    inline = [
      "echo check connection"
    ]
  }

}
