resource "yandex_vpc_network" "test-sg-network" {
  name = "test-sg-network"
}

resource "yandex_vpc_subnet" "test-sg-subnet" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.test-sg-network.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  depends_on = [
    yandex_vpc_network.test-sg-network,
  ]
}

resource "yandex_vpc_security_group" "test-sg" {
  name        = "Test security group"
  description = "Description for security group"
  network_id  = yandex_vpc_network.test-sg-network.id

  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает входящий трафик из 10.5.0.0/24 на указанный порт. Добавьте или измените порт на нужный вам."
    v4_cidr_blocks = ["10.5.0.0/24"]
    port           = 8080
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}