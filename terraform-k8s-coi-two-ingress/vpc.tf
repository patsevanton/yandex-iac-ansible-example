data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-a" {
  name = "default-ru-central1-a"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}

data "yandex_vpc_subnet" "default-ru-central1-c" {
  name = "default-ru-central1-c"
}

resource "yandex_vpc_address" "grafana_address" {
  name = "grafana"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_vpc_address" "consul_address" {
  name = "consul"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}