data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-a" {
  name = "default-ru-central1-a"
}

data "yandex_vpc_subnet" "default-ru-central1-b" {
  name = "default-ru-central1-b"
}

data "yandex_vpc_subnet" "default-ru-central1-d" {
  name = "default-ru-central1-d"
}

#resource "yandex_vpc_address" "promgrafana_address" {
#  name = "promgrafana"
#  external_ipv4_address {
#    zone_id = "ru-central1-a"
#  }
#}
