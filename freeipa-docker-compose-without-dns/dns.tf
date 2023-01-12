resource "yandex_dns_zone" "apatsev_org_ru" {
  name   = "apatsev-org-ru"
  zone   = "apatsev.org.ru."
  public = true
}

resource "yandex_dns_recordset" "freeipa_apatsev_org_ru" {
  zone_id = yandex_dns_zone.apatsev_org_ru.id
  name    = "freeipa.apatsev.org.ru."
  type    = "A"
  ttl     = 200
  data    = [module.freeipa.external_ip[0]]
}
