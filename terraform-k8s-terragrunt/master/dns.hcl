terraform {
  source = "github.com/darzanebor/terraform-yandex-dns.git?ref=main"
}

include {
  path = find_in_parent_folders()
}

locals {
  zones = {
    "example.com" = {
      name = "example-com-zone-name",
      public = true,
      records = [
        { name = "www",             type = "CNAME",ttl   = 3600,  records = ["example.com."] },
        { name = "*.dev",           type = "CNAME",ttl   = 3600,  records = ["example.com."] },
        { name = "*.prod",          type = "CNAME",ttl   = 3600,  records = ["example.com."] },
        { name = "",                type = "A",    ttl   = 3600,  records = ["1.0.0.1",] },
        { name = "",                type = "MX",   ttl   = 3600,  records = ["10 mx.example.com.",] },
        { name = "",                type = "TXT",  ttl   = 3600,  records = ["v=spf1 redirect=_spf.example.com"] },
      ]
    },
  }
}

inputs = {
  for_each         = local.zones
  domain_name      = each.key
  records          = lookup(each.value, "records")
  public           = lookup(each.value, "public")
  zone_name        = lookup(each.value, "name")
  private_networks = lookup(each.value, "private_networks", null)
}
