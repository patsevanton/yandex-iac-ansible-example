terraform {
  source = "github.com/patsevanton/terraform-yandex-dns.git//.?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc-address" {
  config_path = "../vpc-address"
  mock_outputs_allowed_terraform_commands = [ "init", "validate", "plan" ]  # only allow mocks  for validate command
  mock_outputs = {
    external_ipv4_address = "fake_external_ipv4_address"
  }
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
