resource "yandex_dns_zone" "apatsev_org_ru" {
  name   = "apatsev-org-ru"
  zone   = "apatsev.org.ru."
  public = true
}

resource "yandex_dns_recordset" "grafana_apatsev_org_ru" {
  zone_id = yandex_dns_zone.apatsev_org_ru.id
  name    = "grafana.apatsev.org.ru."
  type    = "A"
  ttl     = 200
  data    = [flatten(flatten(yandex_lb_network_load_balancer.sni_balancer.listener)[0].external_address_spec)[0].address]
}

resource "yandex_dns_recordset" "consul_apatsev_org_ru" {
  zone_id = yandex_dns_zone.apatsev_org_ru.id
  name    = "consul.apatsev.org.ru."
  type    = "A"
  ttl     = 200
  data    = [flatten(flatten(yandex_lb_network_load_balancer.sni_balancer.listener)[0].external_address_spec)[0].address]
}
