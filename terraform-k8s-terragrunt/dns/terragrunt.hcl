terraform {
  source = "github.com/patsevanton/terraform-yandex-dns.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc-address" {
  config_path = "../vpc-address"
}

inputs = {
  description = "grafana"
  zone = "apatsev.org.ru."
  name = "apatsev-org-ru"
  public = true
  recordset = [
    {
      name = "grafana.apatsev.org.ru."
      type = "A"
      ttl  = 600
      data = [dependency.vpc-address.outputs.external_ipv4_address]
    },
  ]
}
