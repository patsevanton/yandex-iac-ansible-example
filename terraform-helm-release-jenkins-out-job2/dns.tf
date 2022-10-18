resource "yandex_dns_zone" "dns_domain" {
  name   = replace(var.dns_domain, ".", "-")
  zone   = join("", [var.dns_domain, "."])
  public = true
}

resource "yandex_dns_recordset" "jenkins_dns_domain" {
  zone_id = yandex_dns_zone.dns_domain.id
  name    = join("", [var.jenkins_dns_name, "."])
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}
