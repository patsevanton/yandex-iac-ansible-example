terraform {
  source = "github.com/patsevanton/terraform-yandex-vpc-address.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  yandex_vpc_address_name = "grafana"
  zone_id                 = "ru-central1-a"
}
