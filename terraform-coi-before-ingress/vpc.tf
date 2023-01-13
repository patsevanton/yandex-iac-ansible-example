data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default-ru-central1-a" {
  name = "default-ru-central1-a"
}
