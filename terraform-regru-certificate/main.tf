provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.common_name

  dns_challenge {
    provider = "regru"
    config = {
      REGRU_USERNAME = var.REGRU_USERNAME
      REGRU_PASSWORD = var.REGRU_PASSWORD
    }
  }
}